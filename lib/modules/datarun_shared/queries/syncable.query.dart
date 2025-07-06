import 'dart:convert';

import 'package:d2_remote/core/annotations/reflectable.annotation.dart';
import 'package:d2_remote/core/datarun/logging/new_app_logging.dart';
import 'package:d2_remote/core/datarun/utilities/date_helper.dart';
import 'package:d2_remote/d2_remote.dart';
import 'package:d2_remote/modules/datarun_shared/entities/syncable.entity.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/sync_summary.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:dio/dio.dart';
import 'package:queue/queue.dart';
import 'package:reflectable/mirrors.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
abstract class SyncableQuery<T extends SyncableEntity> extends BaseQuery<T> {
  SyncableQuery({Database? database}) : super(database: database);
  String? assignment;
  String? team;
  String? orgUnit;
  String? form;
  int? version;

  // T fromJsonInstance(Map<String, dynamic> entityMap) {
  //   ClassMirror classMirror =
  //       AnnotationReflectable.reflectType(T) as ClassMirror;
  //   return classMirror.newInstance('fromJson', [entityMap]) as T;
  // }

  SyncableQuery<T> byFormTemplate(String form) {
    this.form = form;
    // this.version = version;
    // final value = '${form}${version != null ? '_$version' : ''}%';
    return this.like(attribute: 'form', value: form);
  }

  /// Not Synced to server at all, no available on server
  /// State = to_post
  /// withNotSyncedState
  SyncableQuery<T> withCompleteState() {
    this.filters?.removeWhere((element) => element.attribute == 'syncFailed');
    this.where(attribute: 'isFinal', value: true);
    return this;
  }

  /// Synced to server with updates to be synced, State = to_update
  SyncableQuery<T> withActiveState() {
    this.filters?.removeWhere((element) => element.attribute == 'syncFailed');
    this.where(attribute: 'isFinal', value: false);
    return this;
  }

  /// Synced to server with No Updates to be synced
  SyncableQuery<T> withSyncedState() {
    this.filters?.removeWhere((element) => element.attribute == 'syncFailed');
    this.where(attribute: 'synced', value: true);
    return this;
  }

  /// Not Synced to server at all, Couldn't be synced
  /// State = to_post but have errors
  SyncableQuery<T> withSyncErrorState() {
    this
        .where(attribute: 'dirty', value: true)
        .where(attribute: 'syncFailed', value: true);
    return this;
  }

  Future<bool> canEdit() async {
    final user = await D2Remote.userModule.user.withAuthorities().getOne();
    if (user == null) {
      return false;
    }

    // final authorities = user.authorities;
    // final haveChvSuperAuth =
    //     authorities?.map((t) => t.authority).contains('ROLE_CHV_SUPERVISOR') ??
    //         false;

    final entity = await getOne();
    // final formVersion =
    //     await FormVersionQuery().byId(entity?.formVersion).getOne();

    return entity?.synced == false ||
        entity?.createdBy != null /*|| haveChvSuperAuth*/;
  }

  /// **2. Preparing SyncableEntity Data for Upload (51%):**
  ///
  /// - It creates three empty lists: `syncableIds`, `teamIds`, and `syncableActivityIds`.
  /// - It iterates through the retrieved syncableEntities (`syncables`) and performs the following for each syncable:
  ///     - Adds the syncable ID to `syncableIds`.
  ///     - Adds the team ID and activity ID of the syncable to their respective lists (`teamIds` and `syncableActivityIds`), removing duplicates if they already exist.
  /// - It retrieves related `SyncableEntityDataValue` entities associated with these syncables using `SyncableEntityDataValueQuery`.
  /// - It retrieves `Activity` entities by their IDs using `ActivityQuery`.
  /// - It retrieves `Team` entities by their IDs using `TeamQuery`.
  ///
  /// **3. Building SyncableEntity Upload Payload (51%):**
  ///
  /// - It iterates through the `syncables` list again.
  /// - For each syncable, it:
  ///     - Sets the `dataValues` property of the syncable to the filtered list of `SyncableEntityDataValue` entities that belong to that specific syncable (using the `syncable` attribute).
  ///     - Replaces the `team` property of the syncable with the full JSON representation of the corresponding `Team` object obtained earlier. (This likely populates additional team details beyond the ID).
  ///     - Replaces the `activity` property of the syncable with the full JSON representation of the corresponding `Activity` object obtained earlier. (This likely populates additional activity details beyond the ID).
  /// - It then uses `SyncableEntity.toUpload` (presumably a static method to convert an SyncableEntity entity to an upload format) to transform each prepared syncable into a format suitable for the DHIS2 server.
  /// - This creates a final list of syncable upload payloads (`syncableUploadPayload`).
  ///
  /// **4. Uploading SyncableEntitys to DHIS2 Server (51%):**
  ///
  /// - It calls `HttpClient.post` to send a POST request to the DHIS2 server's endpoint specified by `apiResourceName` (likely "syncables.json").
  /// - The request body contains the `syncableUploadPayload` as the value for the key "syncables".
  /// - It likely uses the provided `dioTestClient` argument for making the HTTP request (if provided, otherwise a default `HttpClient` might be used).
  ///
  /// **5. Updating Progress and Saving Import Summaries (75%):**
  ///
  /// - It updates the progress message to indicate upload completion and sets the progress to 75%.
  /// - It extracts the `importSummaries` list from the server response (assuming the response contains import summaries for each uploaded syncable).
  /// - It creates a queue with a maximum parallel execution of 50 using `Queue`.
  /// - It iterates through the `syncables` list again.
  ///     - For each syncable, it finds the corresponding import summary from the `importSummaries` list based on the syncable's ID (assuming the DHIS2 server provides a reference ID in the summary).
  ///     - If an import summary is found:
  ///         - It increments a counter (`availableItemCount`) to track the number of syncables with import summaries.
  ///         - It updates the syncable's properties based on the import summary:
  ///             - `synced`: Set to `True` if the import status is not "ERROR".
  ///             - `dirty`: Set to `True`.
  ///             - `syncFailed`: Set to `True` if the import status is "ERROR".
  ///             - `lastSyncDate`: Set to the current date and time.
  ///             - `lastSyncSummary`: Set to an `SyncableEntityImportSummary` object parsed from the import summary data.
  ///         - It adds a task to the queue to save the updated syncable using `SyncableEntityQuery().setData(syncable).save()`.
  /// - If `availableItemCount` is zero (no import summaries found for any syncables), it cancels the queue.
  /// - Otherwise, it waits for all tasks in the queue to complete (`await queue.onComplete`).
  /// - It updates the progress message to indicate import summaries are saved successfully and sets the progress to 100%.
  ///
  /// **6. Returning Uploaded SyncableEntitys (100%):**
  ///
  /// - **Commented-out approach:** The code originally had a commented-out section that likely aimed to
  ///

  Future<List<T>?> upload({Dio? dioTestClient}) async {
    List<T> syncableEntities = await this
        .where(attribute: 'isFinal', value: true)
        // .where(attribute: 'synced', value: false)
        .where(attribute: 'dirty', value: true)
        .get();

    List<String> syncableEntityIds = [];
    List<String> syncableTeamIds = [];
    List<String> syncableAssignments = [];

    syncableEntities.forEach((event) {
      syncableEntityIds.add(event.id as String);

      syncableAssignments.removeWhere((id) => id == event.assignment);
      if (event.assignment != null) {
        syncableAssignments.add(event.assignment!);
      }

      syncableTeamIds.removeWhere((id) => id == event.team);
      syncableTeamIds.add(event.team);
    });

    final uploadPayload = syncableEntities.map((event) {
      return event.toUpload();
    }).toList();

    final response = await HttpClient.post(
        '${this.apiResourceName as String}/bulk', uploadPayload,
        database: this.database, dioTestClient: dioTestClient);

    SyncSummary summary = SyncSummary.fromJson(response.body);
    logDebug(jsonEncode(uploadPayload.first), data: {"data": uploadPayload});

    final queue = Queue(parallel: 50);
    num availableItemCount = 0;

    for (var syncableEntity in syncableEntities) {
      final syncFailed = summary.failed.containsKey(syncableEntity.id);
      final syncCreated = summary.created.contains(syncableEntity.id);
      final syncUpdated = summary.updated.contains(syncableEntity.id);
      T newEntity = syncableEntity;
      ClassMirror classMirror =
          AnnotationReflectable.reflectType(T) as ClassMirror;
      if (syncCreated || syncUpdated) {
        // syncableEntity.synced = true;
        // syncableEntity.dirty = false;
        // syncableEntity.syncFailed = false;
        // syncableEntity.lastSyncDate = DateHelper.nowUtc();
        // syncableEntity.lastSyncMessage = null;

        newEntity = classMirror.newInstance('fromJson', [
          {
            ...newEntity.toJson(),
            "synced": true,
            "lastSyncMassage": null,
            "syncFailed": false,
            "lastSyncDate": DateHelper.nowUtc(),
            "dirty": false,
            "lastModifiedDate": DateHelper.nowUtc(),
          }
        ]) as T;
        availableItemCount++;
      } else if (syncFailed) {
        // syncableEntity.synced = false;
        // syncableEntity.dirty = true;
        // syncableEntity.syncFailed = true;
        // syncableEntity.lastSyncDate = DateHelper.nowUtc();
        // syncableEntity.lastSyncMessage = summary.failed[syncableEntity.id];
        newEntity = classMirror.newInstance('fromJson', [
          {
            ...newEntity.toJson(),
            "synced": false,
            "lastSyncMassage": summary.failed[syncableEntity.id],
            "syncFailed": true,
            "lastSyncDate": DateHelper.nowUtc(),
            "dirty": true,
            "lastModifiedDate": DateHelper.nowUtc(),
          }
        ]) as T;

        availableItemCount++;
      }

      queue.add(() => setDataAndSave(newEntity));
    }

    if (availableItemCount == 0) {
      queue.cancel();
    } else {
      await queue.onComplete;
    }
    return syncableEntities;
  }

  Future setDataAndSave(T data) {
    throw UnimplementedError();
  }
}

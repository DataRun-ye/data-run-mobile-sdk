import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/form/entities/metadata_submission_update.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:dio/dio.dart';
import 'package:queue/queue.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
// @Query(type: QueryType.METADATA)
class MetadataSubmissionUpdateQuery
    extends BaseQuery<MetadataSubmissionUpdate> {
  MetadataSubmissionUpdateQuery({Database? database})
      : super(database: database);
  Future<List<MetadataSubmissionUpdate>?> upload(List<String> submissionsIds,
      {Dio? dioTestClient}) async {
    List<MetadataSubmissionUpdate> syncableEntities =
        await this.where(attribute: 'dirty', value: true).get();

    //
    // List<String> syncableEntityIds = [];
    // List<String> syncableTeamIds = [];
    // List<String> syncableActivityIds = [];

    // syncableEntities.forEach((event) {
    //   syncableEntityIds.add(event.id as String);
    //
    //   syncableActivityIds.removeWhere((id) => id == event.activity);
    //   syncableActivityIds.add(event.activity);
    //
    //   syncableTeamIds.removeWhere((id) => id == event.team);
    //   syncableTeamIds.add(event.team);
    // });

    // List<Activity> activities =
    //     await ActivityQuery().byIds(syncableActivityIds).get();
    //
    // List<Team> teams = await TeamQuery().byIds(syncableTeamIds).get();

    // final uploadPayload = syncableEntities.map((event) {
    //   // final team = teams.lastWhere((team) => team.id == event.team).toJson();
    //   //
    //   // final activity = activities
    //   //     .lastWhere((activity) => activity.id == event.activity)
    //   //     .toJson();
    //
    //   return event.toUpload();
    // }).toList();

    // final response = await HttpClient.post(
    //     '${this.apiResourceName as String}/bulk', uploadPayload,
    //     database: this.database, dioTestClient: dioTestClient);

    // SyncSummary summary = SyncSummary.fromJson(response.body);

    final queue = Queue(parallel: 50);
    num availableItemCount = 0;

    // for (var syncableEntity in syncableEntities) {
    //   final syncFailed = summary.failed.containsKey(syncableEntity.id);
    //   final syncCreated = summary.created.contains(syncableEntity.id);
    //   final syncUpdated = summary.updated.contains(syncableEntity.id);
    //
    //   // queue.add(() => setDataAndSave(syncableEntity));
    // }

    if (availableItemCount == 0) {
      queue.cancel();
    } else {
      await queue.onComplete;
    }
    return syncableEntities;
  }
}

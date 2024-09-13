import 'dart:convert';

import 'package:d2_remote/core/annotations/column.annotation.dart';
import 'package:d2_remote/core/annotations/entity.annotation.dart';
import 'package:d2_remote/core/annotations/reflectable.annotation.dart';
import 'package:d2_remote/modules/data/tracker/models/event_import_summary.dart';
import 'package:d2_remote/modules/data/tracker/models/geometry.dart';
import 'package:d2_remote/modules/datarun_shared/entities/syncable.entity.dart';

@AnnotationReflectable
@Entity(tableName: 'dataSubmission', apiResourceName: 'dataSubmissions')
class DataFormSubmission extends SyncableEntity {
  @Column(nullable: true, type: ColumnType.TEXT)
  final Map<String, dynamic> formData = {};

  DataFormSubmission({
    String? id,
    String? uid,
    String? name,
    String? code,
    Map<String, dynamic> formData = const {},
    String? createdDate,
    String? lastModifiedDate,

    /// Syncable
    required int version,
    required dynamic form,
    bool? deleted,
    bool? synced,
    bool? syncFailed,
    String? lastSyncDate,
    String? lastSyncMessage,
    EventImportSummary? lastSyncSummary,
    String? startEntryTime,
    String? finishedEntryTime,
    dynamic activity,
    dynamic team,
    required String? orgUnit,
    required String status,
    Geometry? geometry,
    required dirty,
  }) : super(
          id: id,
          uid: uid,
          name: name,
          code: code,
          createdDate: createdDate,
          lastModifiedDate: lastModifiedDate,

          /// Syncable
          form: form,
          version: version,
          deleted: deleted,
          synced: synced,
          syncFailed: syncFailed,
          lastSyncDate: lastSyncDate,
          lastSyncMessage: lastSyncMessage,
          lastSyncSummary: lastSyncSummary,
          startEntryTime: startEntryTime,
          finishedEntryTime: finishedEntryTime,
          activity: activity,
          team: team,
          orgUnit: orgUnit,
          status: status,
          geometry: geometry,
          dirty: dirty,
        ) {
    this.formData.addAll(formData);
  }

  // From JSON string (Database and API)
  factory DataFormSubmission.fromJson(Map<String, dynamic> json) {
    final dynamic lastSyncSummary = json['lastSyncSummary'] != null
        ? EventImportSummary.fromJson(jsonDecode(json['lastSyncSummary']))
        : null;
    final activity = json['activity'] != null
        ? json['activity'] is String
            ? json['activity']
            : json['activity']['uid']
        : null;

    final Geometry? geometry = json["geometry"] != null
        ? Geometry.fromJson(json["geometry"].runtimeType == String
            ? jsonDecode(json["geometry"])
            : json["geometry"])
        : null;

    Map<String, dynamic> parseFormData(dynamic data) {
      if (data == null || (data is String && data.isEmpty)) {
        return {};
      }
      return Map<String, dynamic>.from(
          data is String ? jsonDecode(data) : data);
    }

    return DataFormSubmission(
      id: json['id'].toString(),
      uid: json['uid'],
      code: json['code'],
      name: json['name'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      formData: parseFormData(json['formData']),

      /// Syncable
      form: json['form'],
      version: json['version'],
      deleted: json['deleted'],
      synced: json['synced'],
      syncFailed: json['syncFailed'],
      lastSyncSummary: lastSyncSummary,
      lastSyncDate: json['lastSyncDate'],
      lastSyncMessage: json['lastSyncMessage'],
      startEntryTime: json['startEntryTime'],
      finishedEntryTime: json['finishedEntryTime'],
      activity: activity,
      team: json['team'] != null
          ? json['team'] is String
              ? json['team']
              : json['team']['uid']
          : null,
      status: json['status'],
      orgUnit:
          json['orgUnit'] is String ? json['orgUnit'] : json['orgUnit']?['uid'],
      geometry: geometry,

      dirty: json['dirty'] ?? false,
    );
  }

  /// To JSON string for Database and API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'code': code,
      'name': name,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'formData': jsonEncode(formData),

      /// Syncable
      'form': form,
      'version': version,
      'deleted': this.deleted,
      'synced': this.synced,
      'syncFailed': this.syncFailed,
      'lastSyncSummary': this.lastSyncSummary != null
          ? jsonEncode(
              (this.lastSyncSummary as EventImportSummary).responseSummary)
          : null,
      'lastSyncDate': this.lastSyncDate,
      'lastSyncMessage': this.lastSyncMessage,
      'startEntryTime': this.startEntryTime,
      'finishedEntryTime': this.finishedEntryTime,
      'activity': activity,
      'team': team,
      'orgUnit': orgUnit,
      'status': this.status,
      'geometry': this.geometry != null
          ? jsonEncode(this.geometry?.geometryData)
          : null,
      'dirty': this.dirty,
    };
  }

  @override
  Map<String, dynamic> toUpload() {
    Map<String, dynamic> syncableToUpload = super.toUpload();

    syncableToUpload.addAll({
      'formData': formData,
    });

    return syncableToUpload;
  }
}

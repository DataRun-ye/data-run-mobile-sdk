import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun/form/models/geometry.dart';
import 'package:d2_remote/modules/metadatarun/teams/entities/d_team.entity.dart';
import 'package:d2_remote/shared/entities/base.entity.dart';
import 'package:d2_remote/shared/enumeration/assignment_status.dart';

@legacy.AnnotationReflectable
class SyncableEntity extends BaseEntity {
  @legacy.Column(nullable: true)
  String? name;

  @legacy.Column(nullable: true)
  String? code;

  @legacy.Column(nullable: true)
  bool? deleted;

  @legacy.Column(nullable: true)
  bool? synced;

  @legacy.Column(nullable: true)
  bool? syncFailed;

  @legacy.Column(nullable: true)
  bool isFinal;

  @legacy.Column(nullable: true)
  String? lastSyncDate;

  @legacy.Column(nullable: true)
  String? lastSyncMessage;

  @legacy.Column(nullable: true)
  String? startEntryTime;

  @legacy.Column(nullable: true)
  String? finishedEntryTime;

  @legacy.Column(nullable: true)
  String? createdBy;

  /// Active=IN_PROGRESS, Completed=COMPLETED
  @legacy.Column(type: legacy.ColumnType.TEXT, nullable: true)
  AssignmentStatus? status;

  @legacy.Column(nullable: true)
  String? rescheduledDate;

  @legacy.Column(nullable: true)
  String? reassignedToTeam;

  @legacy.Column(nullable: false, type: legacy.ColumnType.INTEGER)
  int version;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  Geometry? geometry;

  // Relations
  @legacy.ManyToOne(table: Team, joinColumnName: 'team')
  dynamic team;

  // @legacy.ManyToOne(table: Activity, joinColumnName: 'activity')
  // dynamic activity;

  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  final String? form;

  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  String formVersion;

  /// assignment id or null if form is not assigned
  @legacy.Column(nullable: true)
  String? assignment;

  @legacy.Column(nullable: true)
  String? orgUnit;

  SyncableEntity(
      {String? id,
      // String? uid,
      this.name,
      this.code,
      String? lastModifiedDate,
      String? createdDate,
      this.createdBy,
      this.assignment,
      this.orgUnit,
      this.form,
      required this.formVersion,
      this.deleted,
      this.synced,
      this.syncFailed,
      this.lastSyncDate,
      this.startEntryTime,
      this.finishedEntryTime,
      this.team,
      this.lastSyncMessage,
      this.isFinal = false,
      // required this.activity,
      this.reassignedToTeam,
      this.geometry,
      this.status,
      required this.version,
      this.rescheduledDate,
      required bool dirty})
      : super(
            id: id,
            // uid: uid,
            dirty: dirty,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate);

  Map<String, dynamic> toUpload() {
    Map<String, dynamic> syncableToUpload = {
      // "id": this.id,
      "uid": this.id,
      "code": this.code,
      "formVersion": this.formVersion,
      "form": form,
      "name": this.name,
      "createdDate": this.createdDate,
      "createdBy": this.createdBy,
      "lastModifiedDate": this.lastModifiedDate,

      /// Syncable
      "version": this.version,
      "deleted": this.deleted,
      "synced": this.synced,
      "lastSyncMassage": this.lastSyncMessage,
      "syncFailed": this.syncFailed,
      "lastSyncDate": this.lastSyncDate,
      "startEntryTime": this.startEntryTime,
      "finishedEntryTime": this.finishedEntryTime,
      "rescheduledDate": this.rescheduledDate,
      "reassignedToTeam": this.reassignedToTeam,
      // "activity": this.activity,
      "team": this.team,
      "assignment": this.assignment,
      "orgUnit": this.orgUnit,
      "status": this.status?.name,
      "isFinal": this.isFinal,
      "geometry": this.geometry != null ? this.geometry?.toJson() : null,
      "dirty": this.dirty,
    };

    // if (activity != null && activity.runtimeType != String) {
    //   syncableToUpload['activity'] = activity['uid'];
    // }

    if (team != null && team.runtimeType != String) {
      syncableToUpload['team'] = team['id'];
    }

    // if (form != null) {
    //   syncableToUpload['form'] = form;
    // } else if (formVersion != null && formVersion.runtimeType != String) {
    //   // make formVersion['uid'];
    //   syncableToUpload['form'] = formVersion['formTemplate'];
    // } else {
    //   final formAndVersion = (formVersion as String).split('_');
    //   syncableToUpload['form'] = formAndVersion[0];
    // }

    return syncableToUpload;
  }
}

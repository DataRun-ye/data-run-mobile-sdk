import 'package:d2_remote/core/annotations/column.annotation.dart';
import 'package:d2_remote/core/annotations/entity.annotation.dart';
import 'package:d2_remote/core/annotations/reflectable.annotation.dart';
import 'package:d2_remote/core/annotations/relation.annotation.dart';
import 'package:d2_remote/modules/activity_management/activity/entities/activity.entity.dart';
import 'package:d2_remote/modules/activity_management/assignment/entities/assignment.entity.dart';
import 'package:d2_remote/modules/activity_management/team/entities/team.entity.dart';
import 'package:d2_remote/modules/data_run/itns/entities/itns_village_houses_detail.entity.dart';
import 'package:d2_remote/modules/data_run/itns/entities/progress_status.entity.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@AnnotationReflectable
@Entity(tableName: 'itnsVillage', apiResourceName: 'itns-villages')
class ItnsVillage extends IdentifiableEntity {
  @Column(nullable: false)
  bool deleted;

  @Column(nullable: true)
  String? workDayDate;

  @Column(nullable: true)
  String? surveytype;

  @Column(nullable: true)
  String? otherReasonComment;

  @Column(nullable: true)
  String? reasonNotcomplete;

  @Column(nullable: true)
  String? settlement;

  @Column(nullable: true)
  String? settlementName;

  @Column(nullable: true)
  String? tlCommenet;

  @Column(nullable: true)
  int? timeSpentHours;

  @Column(nullable: true)
  int? timeSpentMinutes;

  @Column(nullable: true)
  String? difficulties;

  @Column(nullable: true)
  String? locationCaptured;

  @Column(nullable: true)
  String? locationCaptureTime;

  @Column(nullable: true)
  String? startEntryTime;

  @Column(nullable: true)
  String? endEntryTime;

  @Column(nullable: true)
  String? finishedEntryTime;

  @Column(nullable: true)
  String? untargetingOtherSpecify;

  @Column(nullable: true)
  String? otherVillageName;

  @Column(nullable: true)
  String? otherVillageCode;

  @Column(nullable: true)
  int? otherTeamNo;

  // Relations
  @ManyToOne(table: Team, joinColumnName: 'team')
  dynamic team;

  @ManyToOne(table: Assignment, joinColumnName: 'assignment')
  dynamic assignment;

  @ManyToOne(table: ProgressStatus, joinColumnName: 'progressStatus')
  dynamic progressStatus;

  @ManyToOne(table: Activity, joinColumnName: 'activity')
  dynamic activity;

  @OneToMany(table: ItnsVillageHousesDetail)
  List<ItnsVillageHousesDetail>? houseDetails;

  ItnsVillage(
      {required String id,
      required this.deleted,
      this.workDayDate,
      this.surveytype,
      this.otherReasonComment,
      this.reasonNotcomplete,
      this.settlement,
      this.settlementName,
      this.tlCommenet,
      this.timeSpentHours,
      this.timeSpentMinutes,
      this.difficulties,
      this.locationCaptured,
      this.locationCaptureTime,
      this.startEntryTime,
      this.endEntryTime,
      this.finishedEntryTime,
      this.untargetingOtherSpecify,
      this.otherVillageName,
      this.otherVillageCode,
      this.otherTeamNo,
      this.activity,
      this.team,
      this.assignment,
      this.progressStatus,
      this.houseDetails,
      String? created,
      String? lastUpdated,
      required String name,
      String? code,
      required dirty})
      : super(
            id: id,
            name: name,
            code: code,
            created: created,
            lastUpdated: lastUpdated,
            dirty: dirty);

  factory ItnsVillage.fromJson(Map<String, dynamic> json) {
    return ItnsVillage(
        id: json['uid'],
        deleted: json['deleted'],
        workDayDate: json['workDayDate'],
        surveytype: json['surveytype'],
        otherReasonComment: json['otherReasonComment'],
        reasonNotcomplete: json['reasonNotcomplete'],
        settlement: json['settlement'],
        settlementName: json['settlementName'],
        tlCommenet: json['tlCommenet'],
        timeSpentHours: json['timeSpentHours'],
        timeSpentMinutes: json['timeSpentMinutes'],
        difficulties: json['difficulties'],
        locationCaptured: json['locationCaptured'],
        locationCaptureTime: json['locationCaptureTime'],
        startEntryTime: json['startEntryTime'],
        endEntryTime: json['endEntryTime'],
        finishedEntryTime: json['finishedEntryTime'],
        untargetingOtherSpecify: json['untargetingOtherSpecify'],
        otherVillageName: json['otherVillageName'],
        otherVillageCode: json['otherVillageCode'],
        otherTeamNo: json['otherTeamNo'],
        name: json['name'],
        code: json['code'],
        created: json['createdDate'],
        lastUpdated: json['lastModifiedDate'],
        houseDetails: (json['houseDetails'] ?? [])
            .map<ItnsVillageHousesDetail>((houseDetail) =>
                ItnsVillageHousesDetail.fromJson({
                  ...houseDetail,
                  'itnsVillage': json['uid'],
                  'dirty': false
                }))
            .toList(),
        team: json['team']['uid'],
        assignment: json['assignment']['uid'],
        progressStatus: json['progressStatus']['uid'],
        activity: json['activity']['uid'],
        dirty: json['dirty']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'createdDate': created,
      'lastModifiedDate': lastUpdated,
      'deleted': deleted,
      'workDayDate': workDayDate,
      'surveytype': surveytype,
      'otherReasonComment': otherReasonComment,
      'reasonNotcomplete': reasonNotcomplete,
      'settlement': settlement,
      'settlementName': settlementName,
      'tlCommenet': tlCommenet,
      'timeSpentHours': timeSpentHours,
      'timeSpentMinutes': timeSpentMinutes,
      'difficulties': difficulties,
      'locationCaptured': locationCaptured,
      'locationCaptureTime': locationCaptureTime,
      'startEntryTime': startEntryTime,
      'endEntryTime': endEntryTime,
      'finishedEntryTime': finishedEntryTime,
      'untargetingOtherSpecify': untargetingOtherSpecify,
      'otherVillageName': otherVillageName,
      'otherVillageCode': otherVillageCode,
      'otherTeamNo': otherTeamNo,
      'name': name,
      'shortName': shortName,
      'code': code,
      'displayName': displayName,
      'dirty': dirty,
      'team': team,
      'assignment': assignment,
      'progressStatus': progressStatus,
      'activity': activity,
    };
  }
}

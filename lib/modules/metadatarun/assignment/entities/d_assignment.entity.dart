import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun_shared/utilities/entity_scope.dart';
import 'package:d2_remote/modules/metadatarun/activity/entities/d_activity.entity.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/entities/org_unit.entity.dart';
import 'package:d2_remote/modules/metadatarun/teams/entities/d_team.entity.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';
import 'package:d2_remote/shared/enumeration/assignment_status.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'assignment', apiResourceName: 'assignments')
class Assignment extends IdentifiableEntity {
  @legacy.ManyToOne(table: Activity, joinColumnName: 'activity')
  dynamic activity;

  @legacy.ManyToOne(table: Team, joinColumnName: 'team')
  dynamic team;

  @legacy.ManyToOne(table: OrgUnit, joinColumnName: 'orgUnit')
  dynamic orgUnit;

  @legacy.Column(nullable: true)
  String? parent;

  @legacy.Column(nullable: true)
  int? startDay;

  @legacy.Column(nullable: true)
  String? startDate;

  @legacy.Column(type: legacy.ColumnType.TEXT, nullable: true)
  AssignmentStatus? status;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  Map<String, Object?> allocatedResources = {};

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  List<String> forms = [];

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  EntityScope? scope;

  Assignment(
      {String? id,
      // required String uid,
      String? createdDate,
      String? lastModifiedDate,
      String? name,
      String? code,
      List<String> forms = const [],
      Map<String, Object?> allocatedResources = const {},
      this.parent,
      this.activity,
      this.orgUnit,
      this.team,
      required this.status,
      this.startDay,
      this.startDate,
      this.scope,
      required dirty})
      : super(
            id: id,
            // uid: uid,
            name: name,
            code: code,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate,
            dirty: dirty) {
    this.forms.addAll(forms);
    this.allocatedResources.addAll(allocatedResources);
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    final scope = EntityScope.getType(json['scope']);
    final status = AssignmentStatus.getType(json['status']);

    final forms = json['forms'] != null
        ? json['forms'].runtimeType == String
            ? jsonDecode(json['forms']).cast<String>()
            : json['forms'].cast<String>()
        : <String>[];

    // final forms = json['forms'] != null
    //     ? json['forms'] is String
    //     ? jsonDecode(json['forms']).cast<String>()
    //     : json['forms'].map<String>((item) => item.toString()).toList()
    //     : <String>[];

    return Assignment(
        id: json['uid'] ?? json['id'].toString(),
        // id: json['id'],
        name: json['name'] ?? json['orgUnit']?['name'],
        allocatedResources: json['allocatedResources'] != null
            ? Map<String, Object?>.from(json['allocatedResources'] is String
                ? jsonDecode(json['allocatedResources'])
                : json['allocatedResources'])
            : <String, Object?>{},
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        code: json['code'],
        activity: json['activity'] != null
            ? json['activity'] is String
                ? json['activity']
                : json['activity']['uid']
            : null,
        orgUnit: json['orgUnit'] != null
            ? json['orgUnit'] is String
                ? json['orgUnit']
                : json['orgUnit']['uid']
            : null,
        parent: json['parent'] != null
            ? json['parent'] is String
                ? json['parent']
                : json['parent']['uid']
            : null,
        team: json['team'] != null
            ? json['team'] is String
                ? json['team']
                : json['team']['uid']
            : null,

        //warehouse,
        status: status,
        startDay: json['startDay'],
        startDate: json['startDate'],
        forms: forms,
        scope: scope,
        dirty: json['dirty']);
  }

  factory Assignment.fromApi(Map<String, dynamic> json) {
    final scope = EntityScope.getType(json['entityScope']);
    final status = AssignmentStatus.getType(json['status']);

    final forms = json['forms'] != null
        ? json['forms'].runtimeType == String
            ? jsonDecode(json['forms']).cast<String>()
            : json['forms'].cast<String>()
        : <String>[];

    // final forms = json['forms'] != null
    //     ? json['forms'] is String
    //     ? jsonDecode(json['forms']).cast<String>()
    //     : json['forms'].map<String>((item) => item.toString()).toList()
    //     : <String>[];

    return Assignment(
        id: json['uid'] ?? json['id'].toString(),
        // uid: json['uid'],
        name: json['name'] ?? json['orgUnit']?['name'],
        allocatedResources: json['allocatedResources'] != null
            ? Map<String, Object?>.from(json['allocatedResources'] is String
                ? jsonDecode(json['allocatedResources'])
                : json['allocatedResources'])
            : <String, Object?>{},
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        code: json['code'],
        activity: json['activity'] != null
            ? json['activity'] is String
                ? json['activity']
                : json['activity']['uid']
            : null,
        orgUnit: json['orgUnit'] != null
            ? json['orgUnit'] is String
                ? json['orgUnit']
                : json['orgUnit']['uid']
            : null,
        parent: json['parent'] != null
            ? json['parent'] is String
                ? json['parent']
                : json['parent']['uid']
            : null,
        team: json['team'] != null
            ? json['team'] is String
                ? json['team']
                : json['team']['uid']
            : null,

        //warehouse,
        status: status,
        startDay: json['startDay'],
        startDate: json['startDate'],
        forms: forms,
        scope: scope,
        dirty: json['dirty']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['displayName'] = this.displayName;
    data['activity'] = this.activity;
    data['orgUnit'] = this.orgUnit;
    data['team'] = this.team;
    data['status'] = this.status?.name;
    data['allocatedResources'] = jsonEncode(this.allocatedResources);
    data['parent'] = this.parent;
    data['createdDate'] = this.createdDate;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['startDay'] = this.startDay;
    data['startDate'] = this.startDate;
    data['forms'] = jsonEncode(this.forms);
    data['scope'] = this.scope!.name;
    data['dirty'] = this.dirty;
    return data;
  }
}

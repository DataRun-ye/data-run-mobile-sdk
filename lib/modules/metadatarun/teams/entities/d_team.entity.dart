import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun_shared/utilities/entity_scope.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/team_form_permission.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'team', apiResourceName: 'teams')
class Team extends IdentifiableEntity {
  // @legacy.ManyToOne(table: Activity, joinColumnName: 'activity')
  // dynamic activity;
  @legacy.Column(nullable: true)
  String? activity;

  @legacy.Column(type: legacy.ColumnType.BOOLEAN)
  bool disabled;

  @legacy.Column(type: legacy.ColumnType.BOOLEAN)
  bool deleteClientData;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  Map<String, Object?> properties = {};

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  List<TeamFormPermission> formPermissions = [];

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  EntityScope? scope;

  Team(
      {String? id,
      // required String uid,
      String? createdDate,
      String? lastModifiedDate,
      String? name,
      String? shortName,
      String? code,
      String? displayName,
      this.activity,
      this.disabled = true,
      this.deleteClientData = false,
      // this.managedTeams,
      Map<String, Object?> properties = const {},
      List<TeamFormPermission> formPermissions = const [],
      this.scope,
      required dirty})
      : super(
            // uid: uid,
            id: id,
            name: name,
            shortName: shortName,
            displayName: displayName,
            code: code,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate,
            dirty: dirty) {
    this.properties.addAll(properties);
    this.formPermissions.addAll(formPermissions);
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    final scope = EntityScope.getType(json['scope']);
    final id = json['uid'] ?? json['id'].toString();
    final formPermissions = json['formPermissions'] != null
        ? (parseDynamicJson(json['formPermissions']) as List)
            .map((permissions) =>
                TeamFormPermission.fromJson({...permissions, 'team': id}))
            .toList()
        : <TeamFormPermission>[];

    return Team(
        id: id,
        name: json['name'],
        shortName: json['shortName'],
        code: json['code'],
        displayName: json['displayName'] ?? json['name'],
        activity: json['activity'] != null
            ? json['activity'] is String?
                ? json['activity']
                : json['activity']['uid']
            : null,
        properties: json['properties'] != null
            ? Map<String, Object>.from(json['properties'] is String
                ? jsonDecode(json['properties'])
                : json['properties'])
            : {},
        disabled: json['disabled'] ?? false,
        deleteClientData: json['deleteClientData'] ?? false,
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        // managedTeams: json['managedTeams'],
        formPermissions: formPermissions,
        scope: scope,
        dirty: json['dirty']);
  }

  factory Team.fromApi(Map<String, dynamic> jsonData) {
    final id = jsonData['uid'] ?? jsonData['id'].toString();

    final activity = jsonData['activity'] is String?
        ? jsonData['activity']
        : jsonData['activity']['uid'];

    final scope = EntityScope.getType(jsonData['entityScope']);

    final formPermissions = jsonData['formPermissions'] != null
        ? (parseDynamicJson(jsonData['formPermissions']) as List)
            .map((permissions) =>
                TeamFormPermission.fromJson({...permissions, 'team': id}))
            .toList()
        : <TeamFormPermission>[];

    return Team(
        id: id,
        name: jsonData['name'],
        shortName: jsonData['shortName'],
        code: jsonData['code'],
        displayName: jsonData['displayName'] ?? jsonData['name'],
        activity: activity,
        disabled: jsonData['disabled'] ?? false,
        deleteClientData: jsonData['deleteClientData'] ?? false,
        properties: jsonData['properties'] != null
            ? Map<String, Object>.from(jsonData['properties'] is String
                ? jsonDecode(jsonData['properties'])
                : jsonData['properties'])
            : {},
        createdDate: jsonData['createdDate'],
        lastModifiedDate: jsonData['lastModifiedDate'],
        formPermissions: formPermissions,
        scope: scope,
        dirty: jsonData['dirty'] ?? false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.id;
    data['name'] = this.name;
    data['shortName'] = this.shortName;
    data['code'] = this.code;
    data['displayName'] = this.displayName;
    data['activity'] = this.activity;
    data['disabled'] = this.disabled;
    data['deleteClientData'] = this.deleteClientData;
    data['createdDate'] = this.createdDate;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['properties'] = jsonEncode(this.properties);
    data['formPermissions'] = jsonEncode((this
        .formPermissions
        .map((permission) => permission.toJson())
        .toList()));
    data['scope'] = this.scope?.name;
    data['dirty'] = this.dirty;
    return data;
  }
}

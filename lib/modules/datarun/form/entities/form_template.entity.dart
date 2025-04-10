import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun/form/entities/form_version.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/form_option.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/option_set.entity.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'formTemplate', apiResourceName: 'dataForm')
class FormTemplate extends IdentifiableEntity {
  /// template latest Version
  @legacy.Column(nullable: false, type: legacy.ColumnType.INTEGER)
  int version;

  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  Map<String, String> label = {};

  @legacy.OneToMany(table: FormVersion)
  List<FormVersion>? formVersions;

  // @legacy.ManyToOne(table: Activity, joinColumnName: 'team')
  // dynamic team;

  FormTemplate({
    String? id,
    // String? uid,
    String? name,
    String? code,
    String? createdDate,
    String? lastModifiedDate,
    required this.version,
    this.formVersions,
    // this.team,
    Map<String, String> label = const {},
    required dirty,
  }) : super(
          id: id,
          // uid: uid,
          name: name,
          code: code,
          createdDate: createdDate,
          lastModifiedDate: lastModifiedDate,
          dirty: dirty,
        ) {
    label.addAll(label);
  }

  // From JSON string (Database and API)
  factory FormTemplate.fromJson(Map<String, dynamic> json) {
    // final team =
    //     json['team'] is String ? json['team'] : json['team']['uid'];

    return FormTemplate(
      id: json['uid'] ?? json['id'].toString(),
      formVersions: List<dynamic>.from(json['formVersions'] ?? [])
          .map((formVersion) => FormVersion.fromJson({
                ...formVersion,
                'id': formVersion['uid'] ?? formVersion['id'].toString(),
                'uid': formVersion['uid'] ?? formVersion['id'].toString(),
                'formTemplate': formVersion['formTemplate'],
              }))
          .toList(),
      // uid: json['uid'],
      code: json['code'],
      name: json['name'],
      label: json['label'] != null
          ? Map<String, String>.from(json['label'] is String
              ? jsonDecode(json['label'])
              : json['label'])
          : {"en": json['name']},
      // team: team,
      version: json['version'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      dirty: json['dirty'] ?? false,
    );
  }

  factory FormTemplate.fromApi(Map<String, dynamic> json) {
    final options = json['options'] != null
        ? (parseDynamicJson(json['options']) as List)
            .map((option) => FormOption.fromJson(option))
            .toList()
        : <FormOption>[];

    final optionSets = Map.fromIterable(options,
            key: (item) => item.listName,
            value: (item) => options.where((t) => t.listName == item.listName))
        .entries
        .map((e) =>
            DOptionSet(listName: e.key, options: e.value.toList()).toJson())
        .toList();

    return FormTemplate(
      id: json['uid'],
      // id: json['uid'],
      formVersions: List<dynamic>.from(json['formVersions'] ?? [])
          .map((formVersion) => FormVersion.fromApi({
                ...formVersion,
                'id': '${formVersion['uid']}_${json['version']}',
                'uid': '${formVersion['uid']}_${json['version']}',
                'formTemplate': json['uid'],
                'version': json['version'],
                // 'activity': formVersion['activity'],
                // 'team': formVersion['team'],
                'optionSets': optionSets,
                'dirty': false
              }))
          .toList(),
      // uid: json['uid'],
      code: json['code'],
      name: json['name'],
      label: json['label'] != null
          ? Map<String, String>.from(json['label'] is String
              ? jsonDecode(json['label'])
              : json['label'])
          : {"en": json['name']},
      // team: team,
      version: json['version'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      dirty: json['dirty'] ?? false,
    );
  }

  /// To JSON string for Database and API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': id,
      'code': code,
      'name': name,
      'version': version,
      // 'team': team,
      'label': jsonEncode(label),
      'formVersions': formVersions,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'dirty': dirty,
    };
  }
}

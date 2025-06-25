import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun/form/entities/form_version.entity.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'formTemplate', apiResourceName: 'dataFormTemplates')
class FormTemplate extends IdentifiableEntity {
  /// template latest Version
  @legacy.Column(nullable: false, type: legacy.ColumnType.INTEGER)
  int versionNumber;

  /// template latest Version
  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  String versionUid;

  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  Map<String, String> label = {};

  @legacy.OneToMany(table: FormVersion)
  List<FormVersion>? formVersions;

  FormTemplate({
    String? id,
    String? name,
    String? code,
    String? createdDate,
    String? lastModifiedDate,
    required this.versionNumber,
    required this.versionUid,
    this.formVersions,
    Map<String, String> label = const {},
    required dirty,
  }) : super(
          id: id,
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
      code: json['code'],
      name: json['name'],
      label: json['label'] != null
          ? Map<String, String>.from(json['label'] is String
              ? jsonDecode(json['label'])
              : json['label'])
          : {"en": json['name']},
      // team: team,
      versionNumber: json['versionNumber'],
      versionUid: json['versionUid'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      dirty: json['dirty'] ?? false,
    );
  }

  factory FormTemplate.fromApi(Map<String, dynamic> json) {
    // final options = json['options'] != null
    //     ? (parseDynamicJson(json['options']) as List)
    //         .map((option) => FormOption.fromJson(option))
    //         .toList()
    //     : <FormOption>[];

    // final optionSets = Map.fromIterable(options,
    //         key: (item) => item.listName,
    //         value: (item) => options.where((t) => t.listName == item.listName))
    //     .entries
    //     .map((e) =>
    //         DOptionSet(listName: e.key, options: e.value.toList()).toJson())
    //     .toList();

    final formId = (json['uid'] ?? json['id']?.toString());
    return FormTemplate(
      id: formId,
      formVersions: List<dynamic>.from(json['formVersions'] ?? [])
          .map((formVersion) => FormVersion.fromApi({
                ...formVersion,
                'id': json['versionUid']!,
                'uid': json['versionUid']!,
                'formTemplate': formId,
                'versionNumber': json['versionNumber']!,
                // 'optionSets': optionSets,
                'dirty': false
              }))
          .toList(),
      code: json['code'],
      name: json['name'],
      label: json['label'] != null
          ? Map<String, String>.from(json['label'] is String
              ? jsonDecode(json['label'])
              : json['label'])
          : {"en": json['name']},
      versionNumber: json['versionNumber'],
      versionUid: json['versionUid'],
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
      'versionNumber': versionNumber,
      'versionUid': versionUid,
      // 'team': team,
      'label': jsonEncode(label),
      'formVersions': formVersions,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'dirty': dirty,
    };
  }
}

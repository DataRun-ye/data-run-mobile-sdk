import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/core/utilities/list_extensions.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_template.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/field_template/field_template.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/field_template/section_template.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/field_template/template.dart';
import 'package:d2_remote/modules/datarun/form/shared/form_option.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/option_set.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/template_extensions/template_path_walking_service.dart';
import 'package:d2_remote/modules/datarun/form/shared/validation_strategy.dart';
import 'package:d2_remote/modules/datarun/form/shared/value_type.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'form_traverse_extension.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'formVersion', apiResourceName: 'formVersions')
class FormVersion extends IdentifiableEntity
    with TemplatePathWalkingService<Template> {
  @legacy.ManyToOne(table: FormTemplate, joinColumnName: 'formTemplate')
  dynamic formTemplate;

  // @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  // List<Template> fields = [];

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  List<FormOption> options = [];

  // @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  // List<DOptionSet> optionSets = [];

  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  Map<String, String> label = {};

  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  String defaultLocal;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  IList<FieldTemplate> fields;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  IList<SectionTemplate> sections;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  String? description;

  @legacy.Column(type: legacy.ColumnType.TEXT, nullable: false)
  ValidationStrategy validationStrategy;

  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  String versionUid;

  /// current Version
  @legacy.Column(nullable: false, type: legacy.ColumnType.INTEGER)
  int versionNumber;

  // @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  // List<Template> flattenedFields = [];

  FormVersion({
    String? id,
    // String? uid,
    String? name,
    String? code,
    String? createdDate,
    String? lastModifiedDate,
    this.description,
    this.formTemplate,
    required this.versionNumber,
    required this.versionUid,
    required this.defaultLocal,
    required this.validationStrategy,
    Iterable<Template> treeFields = const [],
    List<FormOption> options = const [],
    List<DOptionSet> optionSets = const [],
    Map<String, String> label = const {},
    List<String> orgUnits = const [],
    Iterable<FieldTemplate>? fields,
    Iterable<SectionTemplate>? sections,
    required dirty,
  })  : this.fields = IList.orNull(fields) ?? IList(),
        this.sections = IList.orNull(sections) ?? IList(),
        this.treeFields = IList.orNull(treeFields) ?? IList(),
        // this.flattenFieldsMap = IMap.orNull(flattenFieldsMap) ?? IMap(),
        super(
          id: id,
          // uid: uid,
          name: name,
          code: code,
          createdDate: createdDate,
          lastModifiedDate: lastModifiedDate,
          dirty: dirty,
        ) {
    this.options.addAll(options);
    // this.optionSets.addAll(optionSets);
    this.label.addAll(label);
  }

  factory FormVersion.fromJson(Map<String, dynamic> json) {
    final validationStrategy =
        ValidationStrategy.getValueType(json['validationStrategy']);

    final orgUnits = json['orgUnits'] != null
        ? json['orgUnits'].runtimeType == String
            ? jsonDecode(json['orgUnits']).cast<String>()
            : json['orgUnits'].cast<String>()
        : <String>[];

    final options = json['options'] != null
        ? (parseDynamicJson(json['options']) as List)
            .map((option) => FormOption.fromJson(option))
            .toList()
        : <FormOption>[];

    final treeFields = json['treeFields'] != null
        ? (parseDynamicJson(json['treeFields']) as List)
            .map((field) => Template.fromJsonFactory(field))
            .toList()
        : <Template>[];

    final fields = json['fields'] != null
        ? (parseDynamicJson(json['fields']) as List)
            .map((field) => FieldTemplate.fromJson(field))
            .toList()
        : <FieldTemplate>[];

    final sections = json['sections'] != null
        ? (parseDynamicJson(json['sections']) as List)
            .map((field) => SectionTemplate.fromJson(field))
            .toList()
        : <SectionTemplate>[];

    final optionSets = json['optionSets'] != null
        ? (parseDynamicJson(json['optionSets']) as List)
            .map((optionSet) => DOptionSet.fromJson(optionSet))
            .toList()
        : <DOptionSet>[];

    return FormVersion(
      id: json['uid'] ?? json['id'].toString(),
      code: json['code'],
      name: json['name'],
      validationStrategy: validationStrategy,
      versionNumber: json['versionNumber'],
      versionUid: json['versionUid'],
      formTemplate: json['formTemplate'],
      label: json['label'] != null
          ? Map<String, String>.from(json['label'] is String
              ? jsonDecode(json['label'])
              : json['label'])
          : {"en": json['name'], "ar": json['name']},
      defaultLocal: json['defaultLocal'] ?? 'en',
      treeFields: treeFields,
      fields: fields,
      sections: sections,
      options: options,
      optionSets: optionSets,
      orgUnits: orgUnits,
      description: json['description'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      dirty: json['dirty'] ?? false,
    );
  }

  factory FormVersion.fromApi(Map<String, dynamic> json) {
    final validationStrategy =
        ValidationStrategy.getValueType(json['validationStrategy']);

    final orgUnits = json['orgUnits'] != null
        ? json['orgUnits'].runtimeType == String
            ? jsonDecode(json['orgUnits']).cast<String>()
            : json['orgUnits'].cast<String>()
        : <String>[];

    final fields = json['fields'] != null
        ? (parseDynamicJson(json['fields']) as List)
            .map((field) => FieldTemplate.fromJson(field))
            .toList()
        : <FieldTemplate>[];

    final sections = json['sections'] != null
        ? (parseDynamicJson(json['sections']) as List)
            .map((field) => SectionTemplate.fromJson(field))
            .toList()
        : <SectionTemplate>[];

    final tree = buildTree(fieldsAndSections: [...sections, ...fields]);

    final options = json['options'] != null
        ? (parseDynamicJson(json['options']) as List)
            .map((option) => FormOption.fromJson(option))
            .toList()
        : <FormOption>[];

    final optionSets = json['optionSets'] != null
        ? (parseDynamicJson(json['optionSets']) as List)
            .map((optionSet) => DOptionSet.fromJson(optionSet))
            .toList()
        : <DOptionSet>[];

    return FormVersion(
      id: json['uid'] ?? json['id']?.toString(),
      code: json['code'],
      name: json['name'],
      validationStrategy: validationStrategy,
      versionNumber: json['versionNumber'],
      versionUid: json['versionUid'],
      formTemplate: json['formTemplate'],
      label: json['label'] != null
          ? Map<String, String>.from(json['label'] is String
              ? jsonDecode(json['label'])
              : json['label'])
          : {"en": json['name'], "ar": json['name']},
      defaultLocal: json['defaultLocal'] ?? 'en',
      treeFields: tree,
      fields: fields,
      sections: sections,
      options: options,
      optionSets: optionSets,
      orgUnits: orgUnits,
      description: json['description'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      dirty: json['dirty'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': id,
      'code': code,
      'name': name,
      'validationStrategy': validationStrategy.name,
      'versionNumber': versionNumber,
      'versionUid': versionUid,
      'formTemplate': formTemplate,
      'label': jsonEncode(label),
      'defaultLocal': defaultLocal,
      'description': description,
      // 'orgUnits': jsonEncode(orgUnits),
      'treeFields':
          jsonEncode(treeFields.map((field) => field.toJson()).toList()),
      'fields':
          jsonEncode(fields.unlock.map((field) => field.toJson()).toList()),
      // jsonEncode(fields.unlock.map((field) => field.toJson()).toList()),
      'sections':
          jsonEncode(sections.unlock.map((field) => field.toJson()).toList()),
      // jsonEncode(sections.unlock.map((field) => field.toJson()).toList()),
      'options': jsonEncode(options.map((option) => option.toJson()).toList()),
      // 'optionSets': jsonEncode(
      //     optionSets.map((optionSet) => optionSet.toJson()).toList()),
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'dirty': dirty,
    };
  }

  @override
  Iterable<Template> get flatFieldsList => [...sections, ...fields];

// @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
// @visibleForTesting
// IMap<String, Template>? flattenFieldsMap;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  IList<Template> treeFields;

// @override
// Iterable<Template> get flatFieldsList => formFlatFields.values;
}

List<Template> buildTree({
  // required List<SectionTemplate> sections,
  required List<Template> fieldsAndSections,
}) {
  // 1) Create a lookup of all nodes by their id:
  final IMap<String, Template> lookup = IMap.fromIterable(fieldsAndSections,
      keyMapper: (template) => template.id!,
      valueMapper: (template) => template);

  // 2) Link children into parents:
  final List<Template> roots = [];
  lookup.forEach((id, node) {
    if (node.parent == null || !lookup.containsKey(node.parent!)) {
      // no parent in our data ⇒ this is a root
      roots.add(node);
    } else {
      lookup[node.parent!]!.children.add(node);
    }
  });

  // 3) Optional: sort each node’s children by the `order` property:
  void sortRecursively(List<Template> list) {
    list.sort((a, b) => a.order.compareTo(b.order));
    for (var n in list) {
      if (n.children.isNotEmpty) sortRecursively(n.children);
    }
  }

  sortRecursively(roots);

  return roots;
}

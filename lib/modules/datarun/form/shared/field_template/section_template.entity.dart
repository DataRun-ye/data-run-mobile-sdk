import 'dart:convert';

import 'package:d2_remote/modules/datarun/form/shared/field_template/template.dart';
import 'package:d2_remote/modules/datarun/form/shared/rule/rule.dart';
import 'package:d2_remote/modules/datarun/form/shared/value_type.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class SectionTemplate extends Template {
  final String? id;
  final String? code;
  final String path;
  final String? description;

  final String? name;
  final int order;

  final ValueType? type;
  final String? fieldValueRenderingType;
  final String? parent;

  // final IList<Template> fields;
  final IMap<String, dynamic> label;

  final IMap<String, dynamic>? properties;

  final IList<Rule> rules;

  final String? constraint;
  final IMap<String, String>? constraintMessage;
  final String? itemTitle;
  final bool readOnly;
  final bool repeatable;
  final int? maxRepeats;
  final int? minRepeats;

  final List<Template> children;

  SectionTemplate({
    this.id,
    this.code,
    required this.path,
    this.description,
    this.order = 0,
    this.type = ValueType.Section,
    this.name,
    this.fieldValueRenderingType,
    this.parent,
    this.itemTitle,
    this.readOnly = false,
    this.repeatable = false,
    this.maxRepeats,
    this.minRepeats,
    this.constraint,
    this.constraintMessage,
    Iterable<Rule>? rules,
    // Iterable<Template>? fields,
    Iterable<Template>? children,
    this.label = const IMap.empty(),
    this.properties,
  })  : this.children = children?.toList() ?? const [],
        this.rules = IList.orNull(rules) ?? const IList<Rule>.empty();

  @override
  List<Object?> get props => [parent, itemTitle, readOnly];

  factory SectionTemplate.fromJson(Map<String, dynamic> json) {
    final valueType = ValueType.getValueType(json['type']);

    final rules = json['rules'] != null
        ? (parseDynamicJson(json['rules']) as List)
            .map<Rule>((ruleField) =>
                Rule.fromJson({...ruleField, 'field': json['name']}))
            .toList()
        : <Rule>[];

    final children = json['children'] != null
        ? (parseDynamicJson(json['children']) as List)
            .map<Template>((field) => Template.fromJsonFactory(
                {...field, "optionMap": json['optionMap']}))
            .toList()
        : <Template>[];
    // final treeFields = <Template>[];

    final label = json['label'] != null
        ? Map<String, String?>.from(
            json['label'] is String ? jsonDecode(json['label']) : json['label'])
        : <String, String?>{};

    final properties = json['properties'] != null
        ? Map<String, dynamic>.from(json['properties'] is String
            ? jsonDecode(json['properties'])
            : json['properties'])
        : <String, dynamic>{};

    final constraintMessage = json['constraintMessage'] != null
        ? Map<String, String>.from(json['constraintMessage'] is String
            ? jsonDecode(json['constraintMessage'])
            : json['constraintMessage'])
        : <String, String>{};

    return SectionTemplate(
        type: valueType,
        constraint: json['constraint'],
        id: json['id'],
        code: json['code'],
        constraintMessage: constraintMessage.lock,
        name: json['name'],
        description: json['description'],
        path: json['path'],
        maxRepeats: json['maxRepeats'],
        minRepeats: json['minRepeats'],
        readOnly: json['readOnly'] ?? false,
        repeatable: json['repeatable'] ?? valueType.isRepeatSection ?? false,
        itemTitle: json['itemTitle'],
        order: json['order'] ?? 0,
        children: children,
        rules: rules,
        label: label.lock,
        properties: properties.lock,
        parent: json['parent'],
        fieldValueRenderingType: json['fieldValueRenderingType']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'order': order,
      'path': path,
      'name': name,
      'description': description,
      'readOnly': readOnly,
      'repeatable': repeatable,
      'maxRepeats': maxRepeats,
      'minRepeats': minRepeats,
      'fieldValueRenderingType': fieldValueRenderingType,
      // 'fields': jsonEncode(treeFields.unlockView
      //     .map((field) => TemplateJsonFactory.toJsonFactory(field))
      //     .toList()),
      'children': children.map((field) => field.toJson()).toList(),
      // jsonEncode(
      //     children.map((field) => field.toJson()).toList()),
      'rules': rules.unlockView.map((rule) => rule.toJson()).toList(),
      // jsonEncode(rules.unlockView.map((rule) => rule.toJson()).toList()),
      'label': label.unlock, //jsonEncode(label.unlockView),
      // 'properties': jsonEncode(properties?.unlockView),
      'constraint': constraint,
      'constraintMessage': constraintMessage!.unlockView,
      /*constraintMessage != null
          ? jsonEncode(constraintMessage!.unlockView)
          : null,*/
      'parent': parent,
    };
  }

  SectionTemplate copyWith({
    String? id,
    String? description,
    String? path,
    int? order,
    String? name,
    String? code,
    bool? mainField,
    Iterable<Rule>? rules,
    // Iterable<Template>? fields,
    Iterable<Template>? children,
    ValueType? type,
    IMap<String, dynamic>? label,
    IMap<String, dynamic>? properties,
    bool? readOnly,
    String? constraint,
    IMap<String, String>? constraintMessage,
    String? fieldValueRenderingType,
    String? parent,
    String? itemTitle,
    bool? repeatable,
    int? maxRepeats,
    int? minRepeats,
  }) {
    return SectionTemplate(
      id: id ?? this.id,
      code: code ?? this.code,
      path: path ?? this.path,
      description: description ?? this.description,
      name: name ?? this.name,
      order: order ?? this.order,
      type: type ?? this.type,
      fieldValueRenderingType:
          fieldValueRenderingType ?? this.fieldValueRenderingType,
      parent: parent ?? this.parent,
      // fields: fields ?? this.fields,
      children: children ?? this.children,
      label: label ?? this.label,
      properties: properties ?? this.properties,
      rules: rules ?? this.rules,
      constraint: constraint ?? this.constraint,
      constraintMessage: constraintMessage ?? this.constraintMessage,
      itemTitle: itemTitle ?? this.itemTitle,
      readOnly: readOnly ?? this.readOnly,
      repeatable: repeatable ?? this.repeatable,
      maxRepeats: maxRepeats ?? this.maxRepeats,
      minRepeats: minRepeats ?? this.minRepeats,
    );
  }
}

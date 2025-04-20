import 'dart:convert';

import 'package:d2_remote/modules/datarun/form/shared/attribute_type.dart';
import 'package:d2_remote/modules/datarun/form/shared/field_template/allowed_action.dart';
import 'package:d2_remote/modules/datarun/form/shared/field_template/scanned_code_properties.dart';
import 'package:d2_remote/modules/datarun/form/shared/field_template/template.dart';
import 'package:d2_remote/modules/datarun/form/shared/form_option.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/metadata_resource_type.dart';
import 'package:d2_remote/modules/datarun/form/shared/rule/rule.dart';
import 'package:d2_remote/modules/datarun/form/shared/value_type.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

mixin ElementAttributesMixin {
  ValueType? get type;

  bool get mandatory;
}

class FieldTemplate extends Template
    with ElementAttributesMixin, EquatableMixin {
  final String? id;
  final String? description;
  final String path;

  final String? code;
  final String? name;
  final int order;

  final ValueType? type;
  final String? listName;
  final String? optionSet;
  final bool mandatory;
  final bool readOnly;
  final bool mainField;
  final String? choiceFilter;
  final dynamic defaultValue;
  final String? parent;

  // final IList<FieldTemplate> fields;
  final IMap<String, dynamic> label;

  final IMap<String, dynamic>? properties;

  final IList<Rule> rules;
  final IList<FormOption> options;

  final String? constraint;
  final IMap<String, String>? constraintMessage;
  final String? calculation;

  final AttributeType? attributeType;
  final ScannedCodeProperties? scannedCodeProperties;
  final IList<String> appearance;
  final bool gs1Enabled;

  /// references to other entities
  final MetadataResourceType? resourceType;
  final String? resourceMetadataSchema;
  final IList<String> displayAttributes;
  final IList<AllowedAction> allowedActions;

  FieldTemplate({
    this.id,
    this.code,
    this.description,
    required this.path,
    this.mandatory = false,
    this.mainField = false,
    this.readOnly = false,
    this.order = 0,
    this.listName,
    this.optionSet,
    this.type,
    this.name,
    // this.fieldValueRenderingType,
    this.resourceType,
    this.resourceMetadataSchema,
    this.choiceFilter,
    this.calculation,
    this.defaultValue,
    this.parent,
    this.attributeType,
    this.gs1Enabled = false,
    // this.itemTitle,
    Iterable<Rule>? rules,
    Iterable<FormOption>? options,
    Iterable<String>? appearance,
    Iterable<String>? displayAttributes,
    Iterable<AllowedAction>? allowedActions,
    // Iterable<FieldTemplate>? fields,
    // List<FieldTemplate> fields = const [],
    // List<FormOption> options = const [],
    this.label = const IMap.empty(),
    this.properties,
    this.scannedCodeProperties,
    this.constraint,
    this.constraintMessage,
  })  : /*this.fields =
            IList.orNull(fields) ?? const IList<FieldTemplate>.empty(),*/
        this.options = IList.orNull(options) ?? const IList<FormOption>.empty(),
        this.rules = IList.orNull(rules) ?? const IList<Rule>.empty(),
        this.appearance =
            IList.orNull(appearance) ?? const IList<String>.empty(),
        this.displayAttributes =
            IList.orNull(displayAttributes) ?? const IList<String>.empty(),
        this.allowedActions =
            IList.orNull(allowedActions) ?? const IList<AllowedAction>.empty();

  @override
  List<Object?> get props => [
        optionSet,
        parent,
        readOnly,
        listName,
        calculation,
        resourceType,
        resourceMetadataSchema,
        choiceFilter,
        defaultValue,
        appearance
      ];

  factory FieldTemplate.fromJson(Map<String, dynamic> json) {
    final valueType = ValueType.getValueType(json['type']);

    final resourceType = json['resourceType'] != null
        ? MetadataResourceType.getType(json['resourceType'])
        : null;

    final rules = json['rules'] != null
        ? (parseDynamicJson(json['rules']) as List)
            .map<Rule>((ruleField) =>
                Rule.fromJson({...ruleField, 'field': json['name']}))
            .toList()
        : <Rule>[];

    final allowedActions = json['allowedActions'] != null
        ? (parseDynamicJson(json['allowedActions']) as List)
            .map<AllowedAction>((action) => AllowedAction.getValueType(action))
            .toList()
        : <AllowedAction>[];

    // final optionMap = json['optionMap'] != null
    //     ? Map<String, List<FormOption>>.from(json['optionMap'] is String
    //         ? jsonDecode(json['optionMap'])
    //         : json['optionMap'])
    //     : <String, List<FormOption>>{};

    // final listName = json['listName'];

    // final options = optionMap[listName] ?? [];

    final label = json['label'] != null
        ? Map<String, String?>.from(
            json['label'] is String ? jsonDecode(json['label']) : json['label'])
        : <String, String?>{};

    final constraintMessage = json['constraintMessage'] != null
        ? Map<String, String>.from(json['constraintMessage'] is String
            ? jsonDecode(json['constraintMessage'])
            : json['constraintMessage'])
        : <String, String>{};

    final properties = json['properties'] != null
        ? Map<String, dynamic>.from(json['properties'] is String
            ? jsonDecode(json['properties'])
            : json['properties'])
        : <String, dynamic>{};

    final appearance = json['appearance'] != null
        ? json['appearance'].runtimeType == String
            ? jsonDecode(json['appearance']).cast<String>()
            : json['appearance'].cast<String>()
        : null;

    final displayAttributes = json['displayAttributes'] != null
        ? json['displayAttributes'].runtimeType == String
            ? jsonDecode(json['displayAttributes']).cast<String>()
            : json['displayAttributes'].cast<String>()
        : null;

    return FieldTemplate(
      type: valueType,
      attributeType: AttributeType.getAttributeType(json['attributeType']),
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      // options: options,
      allowedActions: allowedActions,
      displayAttributes: displayAttributes,
      path: json['path'],
      order: json['order'] ?? 0,
      mandatory: json['mandatory'] ?? false,
      mainField: json['mainField'] ?? false,
      readOnly: json['readOnly'] ?? false,
      gs1Enabled: json['gs1Enabled'] ?? false,
      listName: json['listName'],
      optionSet: json['optionSet'],
      // fields: fields,
      // itemTitle: json['itemTitle'],
      choiceFilter: json['choiceFilter'],
      calculation: json['calculation'],
      rules: rules,
      label: label.lock,
      properties: properties.lock,
      parent: json['parent'],
      // parentPath: json['parentPath'],
      resourceType: resourceType,
      resourceMetadataSchema: json['resourceMetadataSchema'],
      // fieldValueRenderingType: json['fieldValueRenderingType'],
      defaultValue: json['defaultValue'] != null
          ? json['defaultValue'] is String
              ? json['defaultValue']
              : json['defaultValue'] as String
          : null,
      constraint: json['constraint'],
      constraintMessage: constraintMessage.lock,
      scannedCodeProperties: json['scannedCodeProperties'],
      appearance: appearance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'type': type?.name,
      'resourceType': resourceType?.name,
      'order': order,
      'path': path,
      'name': name,
      'description': description,
      'options': options.unlockView.map((option) => option.toJson()).toList(),
      /*jsonEncode(
          options.unlockView.map((option) => option.toJson()).toList()),*/
      'mandatory': mandatory,
      'readOnly': readOnly,
      'mainField': mainField,
      'listName': listName,
      'optionSet': optionSet,
      // 'itemTitle': itemTitle,
      'choiceFilter': choiceFilter,
      'calculation': calculation,
      'defaultValue': defaultValue,
      'resourceMetadataSchema': resourceMetadataSchema,
      // 'fieldValueRenderingType': fieldValueRenderingType,
      // 'fields':
      //     jsonEncode(fields.unlockView.map((field) => field.toJson()).toList()),
      'rules': rules.unlockView.map((rule) => rule.toJson()).toList(),
      // jsonEncode(rules.unlockView.map((rule) => rule.toJson()).toList()),
      'label': label.unlockView,
      //jsonEncode(label.unlockView),
      'constraint': constraint,
      'constraintMessage': constraintMessage?.unlockView,
      /*constraintMessage != null
          ? jsonEncode(constraintMessage!.unlockView)
          : null,*/
      // 'properties': jsonEncode(properties?.unlockView),
      'parent': parent,
      'appearance': appearance.unlockView,
      //jsonEncode(appearance.unlockView),
      'scannedCodeProperties': scannedCodeProperties?.toJson(),
    };
  }

  FieldTemplate copyWith({
    String? id,
    String? description,
    String? path,
    int? order,
    String? name,
    String? code,
    bool? mainField,
    Iterable<Rule>? rules,
    Iterable<Template>? fields,
    Iterable<Template>? treeFields,
    ValueType? type,
    IMap<String, dynamic>? label,
    IMap<String, dynamic>? properties,
    bool? readOnly,
    String? constraint,
    IMap<String, String>? constraintMessage,
    String? listName,
    String? optionSet,
    bool? mandatory,
    String? choiceFilter,
    dynamic defaultValue,
    String? parent,
    Iterable<FormOption>? options,
    String? calculation,
    AttributeType? attributeType,
    ScannedCodeProperties? scannedCodeProperties,
    Iterable<String>? appearance,
    bool? gs1Enabled,
    MetadataResourceType? resourceType,
    String? resourceMetadataSchema,
    Iterable<String>? displayAttributes,
    Iterable<AllowedAction>? allowedActions,
  }) {
    return FieldTemplate(
      id: id ?? this.id,
      description: description ?? this.description,
      path: path ?? this.path,
      code: code ?? this.code,
      name: name ?? this.name,
      order: order ?? this.order,
      type: type ?? this.type,
      listName: listName ?? this.listName,
      optionSet: optionSet ?? this.optionSet,
      mandatory: mandatory ?? this.mandatory,
      readOnly: readOnly ?? this.readOnly,
      mainField: mainField ?? this.mainField,
      choiceFilter: choiceFilter ?? this.choiceFilter,
      defaultValue: defaultValue ?? this.defaultValue,
      parent: parent ?? this.parent,
      label: label ?? this.label,
      properties: properties ?? this.properties,
      rules: rules ?? this.rules,
      options: options ?? this.options,
      constraint: constraint ?? this.constraint,
      constraintMessage: constraintMessage ?? this.constraintMessage,
      calculation: calculation ?? this.calculation,
      attributeType: attributeType ?? this.attributeType,
      scannedCodeProperties:
          scannedCodeProperties ?? this.scannedCodeProperties,
      appearance: appearance ?? this.appearance,
      gs1Enabled: gs1Enabled ?? this.gs1Enabled,
      resourceType: resourceType ?? this.resourceType,
      resourceMetadataSchema:
          resourceMetadataSchema ?? this.resourceMetadataSchema,
      displayAttributes: displayAttributes ?? this.displayAttributes,
      allowedActions: allowedActions ?? this.allowedActions,
    );
  }

  @override
  bool get repeatable => false;
}

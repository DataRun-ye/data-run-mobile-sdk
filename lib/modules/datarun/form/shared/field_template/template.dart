import 'package:d2_remote/modules/datarun/form/shared/field_template/section_template.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/rule/rule.dart';
import 'package:d2_remote/modules/datarun/form/shared/template_extensions/template_path_walking_service.dart';
import 'package:d2_remote/modules/datarun/form/shared/value_type.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'field_template.entity.dart';

abstract class Template with EquatableMixin, TreeElement {
  String? get id;

  String? get description;

  String? get parent;

  String get path;

  int get order;

  String? get optionSet => null;

  String? get name;

  String? get code;

  bool get mainField => false;

  IList<Rule>? get rules;

  // IList<Template> get fields => const IList.empty();

  final List<Template> children = [];

  ValueType? get type;

  IMap<String, dynamic> get label;

  IMap<String, dynamic>? get properties;

  bool get readOnly;

  String? get constraint;

  bool get repeatable;

  IMap<String, String>? get constraintMessage;

  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [
        id,
        code,
        path,
        name,
        description,
        type,
        rules,
        label,
        properties,
        readOnly,
        constraint
      ];

  // Template copyWith({
  //   String? id,
  //   String? description,
  //   String? path,
  //   int? order,
  //   String? name,
  //   String? code,
  //   bool? mainField,
  //   Iterable<Rule>? rules,
  //   Iterable<Template>? fields,
  //   Iterable<Template>? treeFields,
  //   ValueType? type,
  //   IMap<String, dynamic>? label,
  //   IMap<String, dynamic>? properties,
  //   bool? readOnly,
  //   String? constraint,
  //   IMap<String, String>? constraintMessage,
  // });

  static Template fromJsonFactory(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final valueType = ValueType.getValueType(type);
    if (type == null || valueType.isSectionType) {
      return SectionTemplate.fromJson(json);
    }
    return FieldTemplate.fromJson(json);
  }

  static Map<String, dynamic> toJsonFactory(Template template) {
    if (template.type == null || template is SectionTemplate) {
      return (template as SectionTemplate).toJson();
    }
    return (template as FieldTemplate).toJson();
  }
}

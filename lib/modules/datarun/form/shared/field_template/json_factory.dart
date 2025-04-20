import 'package:d2_remote/modules/datarun/form/shared/field_template/field_template.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/field_template/section_template.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/field_template/template.dart';
import 'package:d2_remote/modules/datarun/form/shared/value_type.dart';

class TemplateJsonFactory {
  // static Template fromJsonFactory(Map<String, dynamic> json) {
  //   final type = json['type'] as String?;
  //   final valueType = ValueType.getValueType(type);
  //
  //   switch (valueType) {
  //     case ValueType.Section:
  //     case ValueType.RepeatableSection:
  //       return SectionTemplate.fromJson(json);
  //     // case ValueType.ScannedCode:
  //     //   return ScannedCodeTemplate.fromJson(json);
  //     default:
  //       return FieldTemplate.fromJson(json);
  //   }
  // }
  //
  // static Map<String, dynamic> toJsonFactory(Template template) {
  //   switch (template.type) {
  //     case ValueType.Section:
  //     case ValueType.RepeatableSection:
  //       return (template as SectionTemplate).toJson();
  //     default:
  //       return (template as FieldTemplate).toJson();
  //   }
  // }
}

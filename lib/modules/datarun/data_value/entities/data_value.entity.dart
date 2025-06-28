import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun/data_value/entities/data_form_submission.entity.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/repeat_instance.entity.dart';
import 'package:d2_remote/modules/datarun/form/shared/value_type.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'dataValue', apiResourceName: 'dataValues')
class DataValue extends IdentifiableEntity {
  /// path of the Repeat in the FormTemplate
  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  final String templatePath;

  /// the nearest repeat parent Instance in ancestry, or null
  @legacy.ManyToOne(table: RepeatInstance, joinColumnName: 'parent')
  final dynamic parent;

  /// the root submission
  @legacy.ManyToOne(table: DataFormSubmission, joinColumnName: 'submission')
  final dynamic submission;

  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  final String dataElement;

  @legacy.Column(nullable: false, type: legacy.ColumnType.BOOLEAN)
  final bool deleted;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final dynamic value;

  // @legacy.Column(nullable: true)
  // bool? synced;

  DataValue(
      {super.id,
      // String? uid,
      super.createdDate,
      super.lastModifiedDate,
      required this.parent,
      required this.submission,
      required this.templatePath,
      required this.dataElement,
      bool? deleted,
      this.value,
      required super.dirty})
      : this.deleted = deleted == true;

  factory DataValue.fromJson(Map<String, dynamic> json) {
    late final value;
    if (json['value'] != null && json['value'] is List) {
      value = jsonEncode(json['value']);
    } else {
      value = json['value'] != null ? json['value'].toString() : null;
    }
    return DataValue(
        id: json['uid'] ?? json['id'].toString(),
        // uid: json['uid'],
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        value: value,
        templatePath: json['templatePath'],
        deleted: json['deleted'],
        dataElement: json['dataElement'],
        parent: json['parent'],
        submission: json['submission'],
        dirty: json['dirty']);
  }

  String serializeValue(ValueType valueType) {
    if (valueType == ValueType.SelectMulti) {
      return jsonEncode(value); // Encode list as JSON
    }
    return value.toString();
  }

  dynamic parseValue(ValueType valueType) {
    if (valueType.isBoolean) return value == 'true';
    if (valueType.isInteger) return int.tryParse(value);
    if (valueType.isNumeric) return double.tryParse(value);
    if (valueType == ValueType.SelectMulti)
      return (jsonDecode(value) as List<String>?) ?? <String>[];
    return value;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'uid': this.id,
      'templatePath': this.templatePath,
      'submission': this.submission,
      'parent': this.parent,
      'deleted': this.deleted,
      'dataElement': this.dataElement,
      'value': this.value,
      'createdDate': this.createdDate,
      'lastModifiedDate': this.lastModifiedDate,
      'dirty': this.dirty
    };
  }

  DataValue delete() {
    return DataValue.fromJson(
        {...this.toJson(), 'deleted': true, 'dirty': true});
  }

  static toUpload(DataValue eventDataValue) {
    return {
      "dataElement": eventDataValue.dataElement,
      "value": eventDataValue.value
    };
  }
}

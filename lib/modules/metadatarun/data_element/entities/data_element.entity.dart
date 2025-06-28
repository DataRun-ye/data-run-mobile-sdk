import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun/form/shared/field_template/allowed_action.dart';
import 'package:d2_remote/modules/datarun/form/shared/field_template/scanned_code_properties.dart';
import 'package:d2_remote/modules/datarun/form/shared/metadata_resource_type.dart';
import 'package:d2_remote/modules/datarun/form/shared/value_type.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'dataElement', apiResourceName: 'dataElements')
class DataElement extends IdentifiableEntity {
  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final String? description;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final ValueType? type;

  @legacy.Column(nullable: true, type: legacy.ColumnType.BOOLEAN)
  final bool mandatory;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final dynamic defaultValue;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final IMap<String, String?> label;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final ScannedCodeProperties? scannedCodeProperties;

  @legacy.Column(nullable: true, type: legacy.ColumnType.BOOLEAN)
  final bool gs1Enabled;

  /// references to other entities
  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final MetadataResourceType? resourceType;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final String? resourceMetadataSchema;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final String? optionSet;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final IList<AllowedAction> allowedActions;

  DataElement(
      {super.id,
      // String? uid,
      super.name,
      super.code,
      super.createdDate,
      super.lastModifiedDate,
      this.description,
      this.mandatory = false,
      this.type,
      this.resourceType,
      this.resourceMetadataSchema,
      this.defaultValue,
      this.gs1Enabled = false,
      this.optionSet,
      Iterable<AllowedAction>? allowedActions,
      this.label = const IMap.empty(),
      this.scannedCodeProperties,
      required super.dirty})
      : this.allowedActions =
            IList.orNull(allowedActions) ?? const IList<AllowedAction>.empty();

  factory DataElement.fromJson(Map<String, dynamic> json) {
    final valueType = ValueType.getValueType(json['type']);

    final resourceType = json['resourceType'] != null
        ? MetadataResourceType.getType(json['resourceType'])
        : null;

    final allowedActions = json['allowedActions'] != null
        ? (parseDynamicJson(json['allowedActions']) as List)
            .map<AllowedAction>((action) => AllowedAction.getValueType(action))
            .toList()
        : <AllowedAction>[];

    final label = json['label'] != null
        ? Map<String, String?>.from(
            json['label'] is String ? jsonDecode(json['label']) : json['label'])
        : <String, String?>{"en": json['name']};
    final optionSet = json['optionSet'];

    return DataElement(
        id: json['uid'] ?? json['id'].toString(),
        // uid: json['uid'],
        code: json['code'],
        name: json['name'],
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        description: json['description'],
        label: label.lock,
        type: valueType,
        allowedActions: allowedActions,
        mandatory: json['mandatory'] ?? false,
        gs1Enabled: json['gs1Enabled'] ?? false,
        optionSet: optionSet != null
            ? optionSet is String
                ? optionSet
                : optionSet['uid']
            : null,
        resourceType: resourceType,
        resourceMetadataSchema: json['resourceMetadataSchema'],
        defaultValue: json['defaultValue'] != null
            ? json['defaultValue'] is String
                ? json['defaultValue']
                : json['defaultValue'] as String
            : null,
        scannedCodeProperties: json['scannedCodeProperties'],
        dirty: json['dirty']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'uid': this.id,
      'code': this.code,
      'name': this.name,
      'description': this.description,
      'createdDate': this.createdDate,
      'lastModifiedDate': this.lastModifiedDate,
      'dirty': this.dirty,
      'type': type?.name,
      'resourceType': resourceType?.name,
      'mandatory': mandatory,
      'gs1Enabled': gs1Enabled,
      'optionSet': optionSet,
      'defaultValue': defaultValue != null ? defaultValue.toString() : null,
      'resourceMetadataSchema': resourceMetadataSchema,
      'label': jsonEncode(label.unlockView),
      'scannedCodeProperties': scannedCodeProperties?.toJson() != null
          ? jsonEncode(scannedCodeProperties!.toJson())
          : null,
    };
  }
}

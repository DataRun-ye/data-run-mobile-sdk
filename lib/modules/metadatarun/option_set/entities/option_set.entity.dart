import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun/form/shared/form_option.entity.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'optionSet', apiResourceName: 'optionSets')
class OptionSet extends IdentifiableEntity {
  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final IList<FormOption> options;

  OptionSet(
      {String? id,
      // String? uid,
      String? name,
      String? code,
      String? createdDate,
      String? lastModifiedDate,
      Iterable<FormOption>? options,
      required dirty})
      : this.options = IList.orNull(options) ?? const IList<FormOption>.empty(),
        super(
            id: id,
            // uid: uid,
            name: name,
            code: code,
            dirty: dirty);

  factory OptionSet.fromJson(Map<String, dynamic> json) {
    final options = json['options'] != null
        ? (parseDynamicJson(json['options']) as List)
            .map((option) => FormOption.fromJson(option))
            .toList()
        : <FormOption>[];

    return OptionSet(
        id: json['uid'] ?? json['id'].toString(),
        // uid: json['uid'],
        code: json['code'],
        name: json['name'],
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        options: options,
        dirty: json['dirty']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'uid': this.id,
      'code': this.code,
      'name': this.name,
      'createdDate': this.createdDate,
      'lastModifiedDate': this.lastModifiedDate,
      'options': jsonEncode(options.unlockView),
      'dirty': this.dirty
    };
  }
}

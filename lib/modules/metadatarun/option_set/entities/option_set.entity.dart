import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/metadatarun/option_set/entities/option.entity.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'optionSet', apiResourceName: 'optionSets')
class OptionSet extends IdentifiableEntity {
  @legacy.OneToMany(table: Option)
  List<Option>? options;

  OptionSet(
      {String? id,
      String? name,
      String? code,
      String? createdDate,
      String? lastModifiedDate,
      this.options,
      required dirty})
      : super(
            id: id,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate,
            name: name,
            code: code,
            dirty: dirty);

  factory OptionSet.fromJson(Map<String, dynamic> json) {
    final String id = json['uid'] ?? json['id'].toString();
    final List<Option> options = json['options'] is List<Option>
        ? json['options']
        : (json['options'] ?? []).map<Option>((item) {
            final option = item is Option ? item.toJson() : item;
            return Option.fromJson({
              ...option,
              'id': option['id'] ?? '${id}_${option['name']}',
              'optionSet': option['optionSet'] ?? id,
              'properties': option['properties'],
              'dirty': option['dirty'] ?? false,
            });
          }).toList();
    return OptionSet(
        id: id,
        code: json['code'],
        name: json['name'],
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        options: options,
        dirty: json['dirty'] ?? false);
  }

  factory OptionSet.fromApi(Map<String, dynamic> json) {
    final String id = json['uid'] ?? json['id'].toString();
    return OptionSet(
        id: id,
        code: json['code'],
        name: json['name'],
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        options: json['options']
                ?.map<Option>((opJson) => Option(
                      id: '${id}_${opJson['name']}',
                      code: opJson['code'],
                      name: opJson['name'],
                      displayName: opJson['displayName'],
                      description: opJson['description'],
                      optionSet: id,
                      label: Map<String, String>.from(opJson['label']!),
                      filterExpression: opJson['filterExpression'],
                      properties: opJson['properties'],
                      sortOrder: opJson['order'],
                      createdDate: opJson['createdDate'],
                      lastModifiedDate: opJson['lastModifiedDate'],
                      dirty: json['dirty'] ?? false,
                    ))
                .toList() ??
            [],
        dirty: json['dirty'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'uid': this.id,
      'code': this.code,
      'name': this.name,
      'createdDate': this.createdDate,
      'lastModifiedDate': this.lastModifiedDate,
      'options': this.options,
      'dirty': this.dirty
    };
  }
}

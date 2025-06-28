import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/metadatarun/option_set/entities/option.entity.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'optionSet', apiResourceName: 'optionSets')
class OptionSet extends IdentifiableEntity {
  // @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  // final IList<FormOption> options;

  @legacy.OneToMany(table: Option)
  List<Option>? options;

  OptionSet(
      {String? id,
      // String? uid,
      String? name,
      String? code,
      String? createdDate,
      String? lastModifiedDate,
      this.options,
      required dirty})
      : super(
            id: id,
            // uid: uid,
            name: name,
            code: code,
            dirty: dirty);

  factory OptionSet.fromJson(Map<String, dynamic> json) {
    // final options = json['options'] != null
    //     ? (parseDynamicJson(json['options']) as List)
    //         .map((option) => FormOption.fromJson(option))
    //         .toList()
    //     : <FormOption>[];

    final String id = json['uid'] ?? json['id'].toString();
    return OptionSet(
        id: id,
        // uid: json['uid'],
        code: json['code'],
        name: json['name'],
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        // options: options,
        options: List<dynamic>.from(json['options'] ?? [])
            .map((option) =>
                Option.fromJson({...option, 'optionSet': id, 'dirty': false}))
            .toList(),
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
      'options': this.options,
      // 'options': jsonEncode(options.unlockView),
      'dirty': this.dirty
    };
  }
}

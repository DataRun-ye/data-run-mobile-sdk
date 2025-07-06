import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/metadatarun/option_set/entities/option.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
class OptionQuery extends BaseQuery<Option> {
  OptionQuery({Database? database}) : super(database: database);
  String? optionSet;

  OptionQuery byOptionSet(String optionSet) {
    this.optionSet = optionSet;
    return this.where(attribute: 'optionSet', value: optionSet);
  }
}

import 'package:d2_remote/modules/metadatarun/option_set/queries/option.query.dart';
import 'package:d2_remote/modules/metadatarun/option_set/queries/option_set.query.dart';

class OptionSetModule {
  static createTables() async {
    await OptionSetQuery().createTable();
    await OptionQuery().createTable();
  }

  OptionQuery get option => OptionQuery();

  OptionSetQuery get optionSet => OptionSetQuery();
}

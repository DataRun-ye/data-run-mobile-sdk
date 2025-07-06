import 'package:d2_remote/modules/metadatarun/data_element/queries/data_element.query.dart';

class DataElementModule {
  static createTables() async {
    return await DataElementQuery().createTable();
  }

  DataElementQuery get dataElement => DataElementQuery();
}

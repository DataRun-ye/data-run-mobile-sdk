import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/data_value.entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DataValueRepository extends DataStore<DataValue> {
  DataValueRepository(super.dbProvider);
}

import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/repeat_instance.entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class RepeatInstanceRepository extends DataStore<RepeatInstance> {
  RepeatInstanceRepository(super.dbProvider);
}

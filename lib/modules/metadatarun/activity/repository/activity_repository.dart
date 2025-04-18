import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/metadatarun/metadatarun.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ActivityRepository extends DataStore<Activity> {
  ActivityRepository(super.dbProvider);
}

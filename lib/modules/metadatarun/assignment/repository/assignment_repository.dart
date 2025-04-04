import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/metadatarun/metadatarun.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AssignmentRepository extends DataStore<Assignment> {
  AssignmentRepository(super.dbProvider);
}

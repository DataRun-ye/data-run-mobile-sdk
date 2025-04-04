import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_version.entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class FormVersionRepository extends DataStore<FormVersion> {
  FormVersionRepository(super.dbProvider);
}

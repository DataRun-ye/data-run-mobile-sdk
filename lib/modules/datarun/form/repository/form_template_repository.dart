import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_template.entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class FormTemplateRepository extends DataStore<FormTemplate> {
  FormTemplateRepository(super.dbProvider);
}

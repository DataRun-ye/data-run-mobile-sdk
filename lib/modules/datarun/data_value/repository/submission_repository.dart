import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/data_form_submission.entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SubmissionRepository extends DataStore<DataFormSubmission> {
  SubmissionRepository(super.dbProvider);
}

import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/datarun/form/entities/metadata_submission.entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class MetadataSubmissionRepository extends DataStore<MetadataSubmission> {
  MetadataSubmissionRepository(super.dbProvider);
}

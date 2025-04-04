import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/datarun/form/entities/metadata_submission_update.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class MetadataSubmissionUpdateRepository
    extends DataStore<MetadataSubmissionUpdate> {
  MetadataSubmissionUpdateRepository(super.dbProvider);
}

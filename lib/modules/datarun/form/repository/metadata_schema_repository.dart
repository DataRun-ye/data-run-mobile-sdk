import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/datarun/form/entities/meta_data_schema.entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class MetadataSchemaRepository extends DataStore<MetadataSchema> {
  MetadataSchemaRepository(super.dbProvider);
}

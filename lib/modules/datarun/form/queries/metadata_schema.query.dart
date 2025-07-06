import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/form/entities/meta_data_schema.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class MetadataSchemaQuery extends BaseQuery<MetadataSchema> {
  MetadataSchemaQuery({Database? database}) : super(database: database);
}

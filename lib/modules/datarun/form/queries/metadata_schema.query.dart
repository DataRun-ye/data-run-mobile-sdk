import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/form/entities/meta_data_schema.entity.dart';
import 'package:d2_remote/modules/datarun/form/repository/metadata_schema_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:injectable/injectable.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
@lazySingleton
class MetadataSchemaQuery extends BaseQuery<MetadataSchema> {
  final MetadataSchemaRepository dataSource;

  MetadataSchemaQuery(this.dataSource) : super(dataSource);
}

import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/metadatarun/data_element/entities/data_element.entity.dart';
import 'package:d2_remote/modules/metadatarun/data_element/repository/data_element_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:injectable/injectable.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
@lazySingleton
class DataElementQuery extends BaseQuery<DataElement> {
  final DataElementRepository dataSource;

  DataElementQuery(this.dataSource) : super(dataSource);
}

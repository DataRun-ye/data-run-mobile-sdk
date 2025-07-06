import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/metadatarun/data_element/entities/data_element.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class DataElementQuery extends BaseQuery<DataElement> {
  DataElementQuery({Database? database}) : super(database: database);
}

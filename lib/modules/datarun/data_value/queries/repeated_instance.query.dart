import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/repeat_instance.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
// @Query(type: QueryType.METADATA)
class RepeatInstanceQuery extends BaseQuery<RepeatInstance> {
  RepeatInstanceQuery({Database? database}) : super(database: database);
}

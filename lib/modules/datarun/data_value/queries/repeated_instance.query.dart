import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/repeat_instance.entity.dart';
import 'package:d2_remote/modules/datarun/data_value/repository/repeat_instance_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:injectable/injectable.dart';

@AnnotationReflectable
// @Query(type: QueryType.METADATA)
@lazySingleton
class RepeatInstanceQuery extends BaseQuery<RepeatInstance> {
  final RepeatInstanceRepository dataSource;

  RepeatInstanceQuery(this.dataSource) : super(dataSource);
}

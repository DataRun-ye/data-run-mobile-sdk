import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/data_value.entity.dart';
import 'package:d2_remote/modules/datarun/data_value/repository/data_value_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:injectable/injectable.dart';

@AnnotationReflectable
@LazySingleton(/*as: BaseQuery<DataValue>*/)
class DataValueQuery extends BaseQuery<DataValue> {
  final DataValueRepository dataSource;

  DataValueQuery(this.dataSource) : super(dataSource);
}

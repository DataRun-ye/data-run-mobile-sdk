import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/metadatarun/option_set/entities/option_set.entity.dart';
import 'package:d2_remote/modules/metadatarun/option_set/repository/option_set_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:injectable/injectable.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
@lazySingleton
class OptionSetQuery extends BaseQuery<OptionSet> {
  final OptionSetRepository dataSource;

  OptionSetQuery(this.dataSource) : super(dataSource);
}

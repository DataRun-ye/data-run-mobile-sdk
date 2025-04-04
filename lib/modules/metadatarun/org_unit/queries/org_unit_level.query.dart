import 'package:d2_remote/core/annotations/nmc/query.annotation.dart';
import 'package:d2_remote/core/annotations/reflectable.annotation.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/entities/org_unit_level.entity.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/repository/org_unit_level_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:injectable/injectable.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
@lazySingleton
class OrgUnitLevelQuery extends BaseQuery<OrgUnitLevel> {
  final OrgUnitLevelRepository dataSource;
  OrgUnitLevelQuery(this.dataSource) : super(dataSource);
}

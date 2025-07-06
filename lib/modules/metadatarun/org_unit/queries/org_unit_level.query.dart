import 'package:d2_remote/core/annotations/nmc/query.annotation.dart';
import 'package:d2_remote/core/annotations/reflectable.annotation.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/entities/org_unit_level.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class OrgUnitLevelQuery extends BaseQuery<OrgUnitLevel> {
  OrgUnitLevelQuery({Database? database}) : super(database: database);
}

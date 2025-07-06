import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/entities/org_unit.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class OrgUnitQuery extends BaseQuery<OrgUnit> {
  OrgUnitQuery({Database? database}) : super(database: database);
}

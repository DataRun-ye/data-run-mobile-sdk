import 'package:d2_remote/modules/metadatarun/org_unit/queries/org_unit.query.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/queries/org_unit_level.query.dart';

class OrgUnitModule {
  static createTables() async {
    await OrgUnitQuery().createTable();
    await OrgUnitLevelQuery().createTable();
  }

  OrgUnitQuery get orgUnit => OrgUnitQuery();

  OrgUnitLevelQuery get ouLevel => OrgUnitLevelQuery();
}

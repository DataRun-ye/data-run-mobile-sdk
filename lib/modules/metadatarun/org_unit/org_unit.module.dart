import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/entities/org_unit.entity.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/queries/org_unit.query.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/queries/org_unit_level.query.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class OrgUnitModule extends RunModule<OrgUnit> {
  final OrgUnitQuery orgUnit;
  final OrgUnitLevelQuery ouLevel;

  OrgUnitModule(this.orgUnit, this.ouLevel);

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await orgUnit.createTable();
    await ouLevel.createTable();
  }

// @disposeMethod
// @override
// FutureOr<void> dispose() async {
//   await unregisterRepositoryAndQuery<OrgUnitLevel>();
//   return super.dispose();
// }
}

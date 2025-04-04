import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/metadatarun/metadatarun.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class TeamModule extends RunModule<Team> {
  final TeamQuery team;

  TeamModule(this.team);

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await team.createTable();
  }

  // @disposeMethod
  // @override
  // FutureOr<void> dispose() async {
  //   return super.dispose();
  // }
}

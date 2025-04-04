import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/metadatarun/option_set/entities/option_set.entity.dart';
import 'package:d2_remote/modules/metadatarun/option_set/queries/option_set.query.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class OptionSetModule extends RunModule<OptionSet> {
  final OptionSetQuery optionSet;

  OptionSetModule(this.optionSet);

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await optionSet.createTable();
  }

  // @disposeMethod
  // @override
  // FutureOr<void> dispose() async {
  //   return super.dispose();
  // }
}

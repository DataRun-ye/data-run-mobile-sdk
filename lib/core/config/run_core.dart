// import 'dart:async';
//
// import 'package:d2_remote/core/config/run_config.dart';
// import 'package:d2_remote/core/database/database_provider.dart';
// import 'package:d2_remote/core/database/run_module.dart';
// import 'package:injectable/injectable.dart';
//
// /// [RunCore] is the Runtime Orchestrator
// /// - Mutable runtime manager.
// /// - Handles initialization sequence.
// /// - Manages component lifecycle.
// /// - Contains actual business logic.
// /// - Maintains runtime state.
// class RunCore {
//   final DatabaseProvider _dbProvider;
//   final List<RunModule> _modules;
//
//   RunCore(
//       {required DatabaseProvider dbProvider, required List<RunModule> modules})
//       : _dbProvider = dbProvider,
//         _modules = modules;
//
//   factory RunCore.from(RunConfig runConfig) {
//     return RunCore(
//       dbProvider: runConfig.dbProvider,
//       modules: runConfig.modules,
//     );
//   }
//
//   Future<void> initialize() async {
//     await _dbProvider.initialize();
//     await Future.wait(_modules.map((m) => m.initialize()));
//   }
//
//   @disposeMethod
//   FutureOr<void> dispose() async {
//     await _dbProvider.closeDatabase();
//     // for (final module in _modules) {
//     //   await module.dispose();
//     // }
//   }
// }

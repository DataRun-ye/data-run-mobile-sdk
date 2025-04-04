// import 'package:d2_remote/core/config/run_database_config.dart';
// import 'package:d2_remote/core/database/database_provider.dart';
// import 'package:d2_remote/core/database/run_module.dart';
// import 'package:d2_remote/core/database/sqflite_database_provider.dart';
// import 'package:d2_remote/modules/auth/user/d_user.module.dart';
// import 'package:d2_remote/modules/datarun/data_value/form_submission.module.dart';
// import 'package:d2_remote/modules/datarun/form/form.module.dart';
// import 'package:d2_remote/modules/metadatarun/metadatarun.dart';
// import 'package:get_it/get_it.dart';
//
// /// [RunConfig]: the Configuration Container.
// /// [RunConfig] can be looked at as the Recipe for setup
// /// *(Multiple configurations possible)*, while [RunCore] is the
// /// Chef executing the recipe *(Single instance per app)*.
// ///
// /// [RunConfig] attributes:
// /// - Immutable blueprint for setup.
// /// - Defines what components to use.
// /// - Can be created multiple times *(different configs for different environments)*.
// /// - Contains no business logic.
// ///
// /// **Example use cases:**
// /// ```dart
// /// // Test config
// /// final testConfig = RunConfig(
// ///   dbProvider: MockDatabase(),
// ///   modules: [TestUserModule]
// /// );
// ///
// /// // Production config
// /// final prodConfig = RunConfig(
// ///   dbProvider: DriftDatabase(),
// ///   modules: [UserModule, OrgUnitModule]
// /// );
// /// ```
// /// Single [RunConfig] can create multiple [RunCore]:
// /// ```dart
// /// final config = RunConfig(...);
// ///
// /// // Main app core
// /// final mainCore = RunCore.from(config);
// ///
// /// // Test core
// /// final testCore = RunCore.from(config);
// /// ```
// class RunConfig {
//   final DatabaseProvider dbProvider;
//   final List<RunModule> modules;
//
//   const RunConfig({
//     required this.dbProvider,
//     required this.modules,
//   });
// }
//
// // Default configuration
// // RunConfig get defaultRunConfig => RunConfig(
// //         dbProvider: SqfliteDatabaseProvider(const RunDatabaseConfig()),
// //         modules: [
// //           GetIt.I<UserModule>(),
// //           GetIt.I<FormModule>(),
// //           GetIt.I<TeamModule>(),
// //           GetIt.I<ProjectModule>(),
// //           GetIt.I<OrgUnitModule>(),
// //           GetIt.I<OptionSetModule>(),
// //           GetIt.I<DataElementModule>(),
// //           GetIt.I<AssignmentModule>(),
// //           GetIt.I<ActivityModule>(),
// //           GetIt.I<FormSubmissionModule>(),
// //           GetIt.I<UserModule>(),
// //         ]);

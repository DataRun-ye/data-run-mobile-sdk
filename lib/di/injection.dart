import 'package:d2_remote/core/config/run_database_config.dart';
import 'package:d2_remote/core/database/database_factory.dart';
import 'package:d2_remote/core/database/database_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final GetIt sdkLocator = GetIt.instance;

@InjectableInit(
    initializerName: r'$initD2RemoteGetIt',
    asExtension: false,
    ignoreUnregisteredTypes: [DatabaseProvider])
Future<GetIt> setupSdkLocator({required RunDatabaseConfig config}) async {
  sdkLocator.reset();
  final databaseProvider = await DatabaseProviderFactory.create(config: config);

  sdkLocator.registerSingleton<DatabaseProvider>(databaseProvider);

  return $initD2RemoteGetIt(sdkLocator);
}

// FutureOr<void> unregisterRepositoryAndQuery<T extends BaseEntity>() async {
//   await GetIt.I.unregister<DataStore<T>>();
//   await GetIt.I.unregister<BaseQuery<T>>();
// }

import 'package:d2_remote/core/config/run_database_config.dart';
import 'package:d2_remote/core/database/database_provider.dart';
import 'package:d2_remote/core/database/sqflite_database_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProviderFactory {

  static Future<DatabaseProvider> create(
      {required RunDatabaseConfig config, DatabaseFactory? databaseFactory}) {
    return SqfliteDatabaseProvider(databaseFactory: databaseFactory)
        .initialize(config: config);
  }
}

import 'dart:async';
import 'dart:io';

import 'package:d2_remote/core/config/run_database_config.dart';
import 'package:d2_remote/core/database/database_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as cipher;

class SqfliteDatabaseProvider extends DatabaseProvider {
  SqfliteDatabaseProvider({this.databaseFactory});

  final DatabaseFactory? databaseFactory;
  late final Database? _database;

  @override
  Database get database => _database!;

  @override
  Future<DatabaseProvider> initialize(
      {required RunDatabaseConfig config}) async {
    if (this.databaseFactory != null) {
      // Use persistent database file for Windows instead of in-memory
      // the current working directory of the project folder (when developing)
      // or the executable directory when running from a release build;
      final currentDir = Directory.current.path;
      // String customPath = join(currentDir, databaseName + '.db');

      final customDir = Directory(currentDir);
      if (!await customDir.exists()) {
        await customDir.create(recursive: true);
      }

      final path = join(currentDir, config.databaseName! + '.db');

      this._database = config.inMemory
          ? await openDatabase(
              inMemoryDatabasePath,
              onConfigure: _onConfigure, /*password: phrase*/
            )
          : await openDatabase(
              path,
              version: config.version,
              onCreate: _createDatabase,
              onConfigure: _onConfigure, /*password: phrase*/
            );
    } else {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, config.databaseName! + '.db');

      this._database = config.inMemory
          ? await cipher.openDatabase(inMemoryDatabasePath,
              onConfigure: _onConfigure, password: config.securityConfig.phrase)
          : await cipher.openDatabase(path,
              version: config.version,
              onCreate: _createDatabase,
              onConfigure: _onConfigure,
              password: config.securityConfig.phrase);
    }

    return this;
  }

  _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = OFF");

    // Set the encryption key for the database
    // db.execute("PRAGMA key = $phrase;");
  }

  void _createDatabase(Database database, int version) async {}

  @override
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}

import 'dart:async';

import 'package:d2_remote/core/config/run_database_config.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseProvider {
  Database get database;

  Future<DatabaseProvider> initialize({required RunDatabaseConfig config});

  Future<void> closeDatabase();
}

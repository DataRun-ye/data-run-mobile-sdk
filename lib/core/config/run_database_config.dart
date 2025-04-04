import 'package:d2_remote/core/config/db_security_config.dart';

class RunDatabaseConfig {
  final bool inMemory;
  final int version;
  final String? databaseName;
  final DbSecurityConfig securityConfig;

  const RunDatabaseConfig(
      {this.inMemory = false,
      this.version = 1,
      this.databaseName,
      DbSecurityConfig? securityConfig})
      : this.securityConfig = securityConfig ??
            const DbSecurityConfig(
                phrase: 'e@ar3-0Fd!g34Ds-3rat3d#Str4r3&-Sdk1abl3');

  RunDatabaseConfig copyWith({
    bool? inMemory,
    int? version,
    String? databaseName,
    DbSecurityConfig? securityConfig,
  }) {
    return RunDatabaseConfig(
      inMemory: inMemory ?? this.inMemory,
      version: version ?? this.version,
      databaseName: databaseName ?? this.databaseName,
      securityConfig: securityConfig ?? this.securityConfig,
    );
  }
}

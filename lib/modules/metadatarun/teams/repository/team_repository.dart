import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/metadatarun/teams/entities/d_team.entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class TeamRepository extends DataStore<Team> {
  TeamRepository(super.dbProvider);
}

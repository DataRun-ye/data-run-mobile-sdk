import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/modules/auth/user/entities/d_user_authority.entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class UserAuthorityRepository extends DataStore<UserAuthority> {
  UserAuthorityRepository(super.dbProvider);
}

import 'package:d2_remote/modules/auth/user/queries/d_user.query.dart';
import 'package:d2_remote/modules/auth/user/queries/d_user_authority.query.dart';

class UserModule {
  static createTables() async {
    await UserQuery().createTable();
    await UserAuthorityQuery().createTable();
  }

  static logOut() async {}

  UserQuery user = UserQuery();

  UserAuthorityQuery userAuthority = UserAuthorityQuery();
}

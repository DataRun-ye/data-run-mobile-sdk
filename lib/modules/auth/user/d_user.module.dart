import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/auth/user/entities/d_user.entity.dart';
import 'package:d2_remote/modules/auth/user/queries/d_user.query.dart';
import 'package:d2_remote/modules/auth/user/queries/d_user_authority.query.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserModule extends RunModule<User> {
  final UserQuery user;
  final UserAuthorityQuery userAuthority;

  UserModule(this.user, this.userAuthority);

  static logOut() async {}

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await user.createTable();
    await userAuthority.createTable();
  }

// @disposeMethod
// @override
// FutureOr<void> dispose() async {
//   await unregisterRepositoryAndQuery<UserAuthority>();
//   return super.dispose();
// }
}

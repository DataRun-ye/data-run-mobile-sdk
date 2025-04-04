import 'package:d2_remote/modules/auth/user/entities/d_user_authority.entity.dart';
import 'package:d2_remote/modules/auth/user/repository/user_authority_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserAuthorityQuery extends BaseQuery<UserAuthority> {
  final UserAuthorityRepository dataSource;

  UserAuthorityQuery(this.dataSource) : super(dataSource);
}

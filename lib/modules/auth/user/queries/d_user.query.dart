import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/auth/user/entities/d_user.entity.dart';
import 'package:d2_remote/modules/auth/user/entities/d_user_authority.entity.dart';
import 'package:d2_remote/modules/auth/user/repository/user_authority_repository.dart';
import 'package:d2_remote/modules/auth/user/repository/user_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:injectable/injectable.dart';
import 'package:reflectable/reflectable.dart';

@LazySingleton(/*as: BaseQuery<UserAuthority>*/)
class UserQuery extends BaseQuery<User> {
  final UserRepository dataSource;
  final UserAuthorityRepository userAuthorityRepository;

  UserQuery(this.dataSource, this.userAuthorityRepository) : super(dataSource);

  UserQuery withAuthorities() {
    final Column? relationColumn = userAuthorityRepository.columns.firstWhere(
        (column) =>
            column.relation?.referencedEntity?.tableName == this.tableName);

    if (relationColumn != null) {
      ColumnRelation relation = ColumnRelation(
          referencedColumn: relationColumn.relation?.attributeName,
          attributeName: 'authorities',
          primaryKey: this.primaryKey?.name,
          relationType: RelationType.OneToMany,
          referencedEntity: Entity.getEntityDefinition(
              AnnotationReflectable.reflectType(UserAuthority) as ClassMirror),
          referencedEntityColumns: Entity.getEntityColumns(
              AnnotationReflectable.reflectType(UserAuthority) as ClassMirror,
              false));
      this.relations.add(relation);
    }

    return this;
  }

// UserQuery withRoles() {
//   final userRole = Repository<UserRole>();
//   final Column? relationColumn = userRole.columns.firstWhere((column) =>
//       column.relation?.referencedEntity?.tableName == this.tableName);
//
//   if (relationColumn != null) {
//     ColumnRelation relation = ColumnRelation(
//         referencedColumn: relationColumn.relation?.attributeName,
//         attributeName: 'roles',
//         primaryKey: this.primaryKey?.name,
//         relationType: RelationType.OneToMany,
//         referencedEntity: Entity.getEntityDefinition(
//             AnnotationReflectable.reflectType(UserRole) as ClassMirror),
//         referencedEntityColumns: Entity.getEntityColumns(
//             AnnotationReflectable.reflectType(UserRole) as ClassMirror,
//             false));
//     this.relations.add(relation);
//   }
//
//   return this;
// }
}

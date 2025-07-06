import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/core/utilities/repository.dart';
import 'package:d2_remote/modules/auth/user/entities/d_user.entity.dart';
import 'package:d2_remote/modules/auth/user/entities/d_user_authority.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite/sqflite.dart';

class UserQuery extends BaseQuery<User> {
  UserQuery({Database? database}) : super(database: database);

  UserQuery withAuthorities() {
    final userAuthority = Repository<UserAuthority>();
    final Column? relationColumn = userAuthority.columns.firstWhere((column) =>
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

import 'package:d2_remote/modules/auth/user/entities/d_user.entity.dart';
import 'package:sqflite/sqflite.dart';

class QueryResource {
  String name;
  String dhisUrl;

  QueryResource({required this.name, required this.dhisUrl});

  static List<QueryResource> getQueryResources(
      {User? currentUser, dynamic enableResources, Database? database}) {
    return QueryResource.getAllResources(database: database);
  }

  static List<QueryResource> getAllResources({Database? database}) {
    return [
      QueryResource(name: 'organisationUnits', dhisUrl: ''),
    ];
  }
}

import 'package:d2_remote/modules/metadatarun/project/queries/d_project.query.dart';

class ProjectModule {
  static createTables() async {
    await ProjectQuery().createTable();
  }

  ProjectQuery get project => ProjectQuery();
}

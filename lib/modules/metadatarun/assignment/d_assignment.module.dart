import 'package:d2_remote/modules/metadatarun/assignment/queries/d_assignment.query.dart';

class AssignmentModule {
  static createTables() async {
    await AssignmentQuery().createTable();
  }

  AssignmentQuery get assignment => AssignmentQuery();
}

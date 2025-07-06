import 'package:d2_remote/modules/metadatarun/activity/queries/d_activity.query.dart';

class ActivityModule {
  static createTables() async {
    return await ActivityQuery().createTable();
  }

  ActivityQuery get activity => ActivityQuery();
}

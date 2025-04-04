import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/metadatarun/activity/entities/d_activity.entity.dart';
import 'package:d2_remote/modules/metadatarun/activity/queries/d_activity.query.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ActivityModule extends RunModule<Activity> {
  final ActivityQuery activity;

  ActivityModule(this.activity);

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await activity.createTable();
  }
}

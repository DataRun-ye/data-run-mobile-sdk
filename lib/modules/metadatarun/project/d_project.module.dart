import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/metadatarun/project/entities/d_project.entity.dart';
import 'package:d2_remote/modules/metadatarun/project/queries/d_project.query.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ProjectModule extends RunModule<Project> {
  final ProjectQuery project;

  ProjectModule(this.project);

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await project.createTable();
  }

  // @disposeMethod
  // @override
  // FutureOr<void> dispose() async {
  //   return super.dispose();
  // }
}

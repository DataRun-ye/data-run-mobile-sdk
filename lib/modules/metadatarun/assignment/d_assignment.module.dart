import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/metadatarun/assignment/entities/d_assignment.entity.dart';
import 'package:d2_remote/modules/metadatarun/assignment/queries/d_assignment.query.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AssignmentModule extends RunModule<Assignment> {
  final AssignmentQuery assignment;

  AssignmentModule(this.assignment);

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await assignment.createTable();
  }
  //
  // @disposeMethod
  // @override
  // FutureOr<void> dispose() async {
  //   return super.dispose();
  // }
}

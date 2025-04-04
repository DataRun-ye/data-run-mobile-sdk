import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/data_form_submission.entity.dart';
import 'package:d2_remote/modules/datarun/data_value/queries/data_form_submission.query.dart';
import 'package:d2_remote/modules/datarun/data_value/queries/data_value.query.dart';
import 'package:d2_remote/modules/datarun/data_value/queries/repeated_instance.query.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class FormSubmissionModule extends RunModule<DataFormSubmission> {
  final DataValueQuery dataValue;
  final RepeatInstanceQuery repeatInstance;
  final DataFormSubmissionQuery formSubmission;

  FormSubmissionModule(
      this.dataValue, this.repeatInstance, this.formSubmission);

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await dataValue.createTable();
    await repeatInstance.createTable();
    await formSubmission.createTable();
  }

  // @disposeMethod
  // FutureOr<void> dispose() async {
  //   await unregisterRepositoryAndQuery<DataValue>();
  //   await unregisterRepositoryAndQuery<RepeatInstance>();
  //   await unregisterRepositoryAndQuery<DataFormSubmission>();
  // }
}

import 'package:d2_remote/modules/datarun/data_value/queries/data_form_submission.query.dart';
import 'package:d2_remote/modules/datarun/data_value/queries/data_value.query.dart';
import 'package:d2_remote/modules/datarun/data_value/queries/repeated_instance.query.dart';

class FormSubmissionModule {
  static createTables() async {
    await DataValueQuery().createTable();
    await RepeatInstanceQuery().createTable();
    await FormSubmissionQuery().createTable();
  }

  FormSubmissionQuery get formSubmission => FormSubmissionQuery();

  DataValueQuery get dataValue => DataValueQuery();

  RepeatInstanceQuery get repeatInstance => RepeatInstanceQuery();
}

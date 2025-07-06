import 'package:d2_remote/modules/datarun/form/queries/form_template.query.dart';
import 'package:d2_remote/modules/datarun/form/queries/form_version.query.dart';
import 'package:d2_remote/modules/datarun/form/queries/metadata_submission.query.dart';
import 'package:d2_remote/modules/datarun/form/queries/metadata_submission_update.query.dart';

class FormModule {
  static createTables() async {
    await FormTemplateQuery().createTable();
    await FormVersionQuery().createTable();
    await MetadataSubmissionQuery().createTable();
    await MetadataSubmissionUpdateQuery().createTable();
  }

  FormTemplateQuery get formTemplate => FormTemplateQuery();

  FormVersionQuery get formTemplateV => FormVersionQuery();

  MetadataSubmissionQuery get metaSubmission => MetadataSubmissionQuery();

  MetadataSubmissionUpdateQuery get metaSubmissionUpdate =>
      MetadataSubmissionUpdateQuery();
}

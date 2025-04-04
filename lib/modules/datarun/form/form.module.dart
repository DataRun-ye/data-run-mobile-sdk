import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_template.entity.dart';
import 'package:d2_remote/modules/datarun/form/queries/form_template.query.dart';
import 'package:d2_remote/modules/datarun/form/queries/form_version.query.dart';
import 'package:d2_remote/modules/datarun/form/queries/metadata_submission.query.dart';
import 'package:d2_remote/modules/datarun/form/queries/metadata_submission_update.query.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class FormModule extends RunModule<FormTemplate> {
  final FormTemplateQuery formTemplate;
  final FormVersionQuery formTemplateV;
  final MetadataSubmissionQuery metaSubmission;
  final MetadataSubmissionUpdateQuery metaSubmissionUpdate;

  FormModule(this.formTemplate, this.formTemplateV, this.metaSubmission,
      this.metaSubmissionUpdate);

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await formTemplate.createTable();
    await formTemplateV.createTable();
    await metaSubmission.createTable();
    await metaSubmissionUpdate.createTable();
  }
  //
  // @disposeMethod
  // @override
  // FutureOr<void> dispose() async {
  //   await unregisterRepositoryAndQuery<FormTemplate>();
  //   await unregisterRepositoryAndQuery<FormVersion>();
  //   await unregisterRepositoryAndQuery<MetadataSubmission>();
  //   await unregisterRepositoryAndQuery<MetadataSubmissionUpdate>();
  //   return super.dispose();
  // }
}

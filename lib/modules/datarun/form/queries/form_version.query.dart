import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_version.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
class FormVersionQuery extends BaseQuery<FormVersion> {
  FormVersionQuery({Database? database}) : super(database: database);
  String? formTemplate;
  int? version;

  /// returns multiple versions
  FormVersionQuery byFormTemplate(String formTemplate) {
    this.formTemplate = formTemplate;
    return this.where(attribute: 'formTemplate', value: formTemplate);
  }
}

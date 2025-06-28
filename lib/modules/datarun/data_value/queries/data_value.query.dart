import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/data_value.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
class DataValueQuery extends BaseQuery<DataValue> {
  DataValueQuery({Database? database}) : super(database: database);
  String? submission;
  String? dataElement;
  String? parent;
  String? templatePath;

  DataValueQuery byTemplatePath(String templatePath) {
    this.templatePath = templatePath;
    return this.where(attribute: 'templatePath', value: templatePath);
  }

  DataValueQuery bySubmission(String submission) {
    this.submission = submission;
    return this.where(attribute: 'submission', value: submission);
  }

  DataValueQuery byParent(String parent) {
    this.parent = parent;
    return this.where(attribute: 'parent', value: parent);
  }

  DataValueQuery byDataElement(String dataElement) {
    this.dataElement = dataElement;
    return this.where(attribute: 'dataElement', value: dataElement);
  }
}

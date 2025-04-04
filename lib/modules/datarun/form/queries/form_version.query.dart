import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_version.entity.dart';
import 'package:d2_remote/modules/datarun/form/repository/form_version_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:d2_remote/shared/queries/base.repository.dart';
import 'package:injectable/injectable.dart';

@AnnotationReflectable
@lazySingleton
class FormVersionQuery extends BaseQuery<FormVersion> {
  final FormVersionRepository dataSource;

  FormVersionQuery(this.dataSource) : super(dataSource);
  String? formTemplate;
  int? version;

  /// returns multiple versions
  BaseRepository<FormVersion> byFormTemplate(String formTemplate) {
    this.formTemplate = formTemplate;
    return this.where(attribute: 'formTemplate', value: formTemplate);
  }
}

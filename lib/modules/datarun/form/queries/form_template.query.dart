import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_template.entity.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_version.entity.dart';
import 'package:d2_remote/modules/datarun/form/repository/form_template_repository.dart';
import 'package:d2_remote/modules/datarun/form/repository/form_version_repository.dart';
import 'package:d2_remote/shared/models/request_progress.model.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:reflectable/reflectable.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
@lazySingleton
class FormTemplateQuery extends BaseQuery<FormTemplate> {
  final FormTemplateRepository dataSource;
  final FormVersionRepository formVersionRepository;

  FormTemplateQuery(this.dataSource, this.formVersionRepository)
      : super(dataSource);
  int? version;

  FormTemplateQuery withFormVersions() {
    final Column? relationColumn = formVersionRepository.columns.firstWhere(
        (column) =>
            column.relation?.referencedEntity?.tableName == this.tableName);

    if (relationColumn != null) {
      ColumnRelation relation = ColumnRelation(
          referencedColumn: relationColumn.relation?.attributeName,
          attributeName: 'formVersions',
          primaryKey: this.primaryKey?.name,
          relationType: RelationType.OneToMany,
          referencedEntity: Entity.getEntityDefinition(
              AnnotationReflectable.reflectType(FormVersion) as ClassMirror),
          referencedEntityColumns: Entity.getEntityColumns(
              AnnotationReflectable.reflectType(FormVersion) as ClassMirror,
              false));
      this.relations.add(relation);
    }

    return this;
  }

  @override
  Future<List<FormTemplate>?> download(Function(RequestProgress, bool) callback,
      {Dio? dioTestClient}) async {
    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message: 'Fetching user assigned Forms....',
            status: '',
            percentage: 0),
        false);

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                'Downloading ${this.apiResourceName?.toLowerCase()} from the server....',
            status: '',
            percentage: 26),
        false);

    final dhisUrl = await this.dataRunUrl();

    final response = await HttpClient.get(dhisUrl,
        database: await this.dataSource.database, dioTestClient: dioTestClient);

    List data;
    data = response.body[this.apiResourceName]?.toList();

    List<Map<String, dynamic>> forms = [];

    for (final form in data) {
      final formVersion = {};
      formVersion.addAll(form);
      if (form['formVersions'] == null ||
          (form['formVersions'] as List).isEmpty) {
        form['formVersions'] = [formVersion];
      }
      forms.add(form);
    }

    this.data = forms.map((dataItem) {
      dataItem['dirty'] = false;
      return FormTemplate.fromApi(dataItem);
    }).toList();

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                'Saving ${data.length} ${this.apiResourceName?.toLowerCase()} into phone database...',
            status: '',
            percentage: 51),
        false);

    await this.save();

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                '${data.length} ${this.apiResourceName?.toLowerCase()} successfully saved into the database',
            status: '',
            percentage: 100),
        true);

    return this.data;
  }
}

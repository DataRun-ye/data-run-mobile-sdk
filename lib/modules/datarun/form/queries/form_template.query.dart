import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/core/utilities/repository.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_template.entity.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_version.entity.dart';
import 'package:d2_remote/shared/models/request_progress.model.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:dio/dio.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class FormTemplateQuery extends BaseQuery<FormTemplate> {
  FormTemplateQuery({Database? database}) : super(database: database);
  int? version;

  // FormTemplateQuery byVersion(int? version) {
  //   this.version = version;
  //
  //   return version != null
  //       ? this.where(attribute: 'version', value: version)
  //       : this;
  // }

  FormTemplateQuery withFormVersions() {
    final formVersion = Repository<FormVersion>();
    final Column? relationColumn = formVersion.columns.firstWhere((column) =>
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
        database: this.database, dioTestClient: dioTestClient);

    List data;
    data = response.body[this.apiResourceName]?.toList() ?? [];

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

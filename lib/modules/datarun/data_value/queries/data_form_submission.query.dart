import 'package:d2_remote/core/annotations/reflectable.annotation.dart';
import 'package:d2_remote/core/datarun/utilities/date_helper.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/data_form_submission.entity.dart';
import 'package:d2_remote/modules/datarun_shared/queries/syncable.query.dart';
import 'package:d2_remote/shared/models/request_progress.model.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:d2_remote/shared/utilities/save_option.util.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
// @Query(type: QueryType.METADATA)
class FormSubmissionQuery extends SyncableQuery<DataFormSubmission> {
  FormSubmissionQuery({Database? database}) : super(database: database);

  @override
  Future setDataAndSave(DataFormSubmission data) {
    return FormSubmissionQuery().setData(data).save();
  }

  @override
  Future delete() async {
    if (this.id != null) {
      final toDelete = await getOne();
      if (toDelete!.synced ?? false) {
        DataFormSubmission deleted = DataFormSubmission.fromJson({
          ...toDelete.toJson(),
          'deleted': !(toDelete.deleted ?? false),
          // 'synced': true,
          'isFinal': true,
          'dirty': true,
          'lastModifiedDate': DateHelper.nowUtc()
        });

        await setData(deleted)
            .save(saveOptions: SaveOptions(skipLocalSyncStatus: true));
      } else {
        super.delete();
      }
    }
  }

  @override
  Future<List<DataFormSubmission>?> download(
      Function(RequestProgress, bool) callback,
      {Dio? dioTestClient}) async {
    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message: 'Fetching user assignments....',
            status: '',
            percentage: 0),
        false);

    final dataRunUrl = '${query.resourceName}/objects?paged=false';

    final response = await HttpClient.get(dataRunUrl,
        database: this.database, dioTestClient: dioTestClient);

    List data = response.body?[this.apiResourceName].toList() ?? [];

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                '${data.length} ${this.apiResourceName?.toLowerCase()} downloaded successfully',
            status: '',
            percentage: 40),
        false);

    this.data = data.map((dataItem) {
      dataItem['dirty'] = false;
      return DataFormSubmission.fromApi(dataItem);
    }).toList();

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                'Saving ${data.length} ${this.apiResourceName?.toLowerCase()} into phone database...',
            status: '',
            percentage: 50),
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

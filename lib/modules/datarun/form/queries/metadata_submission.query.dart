import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/form/entities/metadata_submission.entity.dart';
import 'package:d2_remote/shared/models/request_progress.model.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class MetadataSubmissionQuery extends BaseQuery<MetadataSubmission> {
  MetadataSubmissionQuery({Database? database}) : super(database: database);

  @override
  Future<List<MetadataSubmission>?> download(
      Function(RequestProgress, bool) callback,
      {Dio? dioTestClient}) async {
    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message: 'Fetching user assigned Teams....',
            status: '',
            percentage: 0),
        false);

    // final List<UserTeam> userTeams = await UserTeamQuery().get();

    // callback(
    //     RequestProgress(
    //         resourceName: this.apiResourceName as String,
    //         message: '${userTeams.length} user assigned Teams found!',
    //         status: '',
    //         percentage: 25),
    //     false);

    // this.whereIn(
    //     attribute: 'id',
    //     values: userTeams.map((userTeam) => userTeam.team).toList(),
    //     merge: false);

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

    List data = response.body[this.apiResourceName]?.toList() ?? [];

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                '${data.length} ${this.apiResourceName?.toLowerCase()} downloaded successfully',
            status: '',
            percentage: 50),
        false);

    this.data = data.map((dataItem) {
      dataItem['dirty'] = false;
      return MetadataSubmission.fromApi(dataItem);
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

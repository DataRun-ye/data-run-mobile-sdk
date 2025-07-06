import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/active_status.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/entity_scope.dart';
import 'package:d2_remote/modules/metadatarun/teams/entities/d_team.entity.dart';
import 'package:d2_remote/shared/models/request_progress.model.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class TeamQuery extends BaseQuery<Team> {
  TeamQuery({Database? database}) : super(database: database);
  String? activity;
  ActiveStatus? activeStatus;

  TeamQuery byActivity(String activity) {
    this.where(attribute: 'activity', value: activity);
    this.activity = activity;
    return this;
  }

  TeamQuery byActivityStatus(ActiveStatus activeStatus) {
    this.activeStatus = activeStatus;
    switch (activeStatus) {
      case ActiveStatus.EnabledOnly:
        this.where(attribute: 'disabled', value: false);
        return this;
      case ActiveStatus.DisabledOnly:
        this.where(attribute: 'disabled', value: true);
        return this;
      default:
        return this;
    }
  }

  Future<List<Team>>? getManagedTeams() async {
    return this.where(attribute: 'scope', value: 'Managed');
  }

  @override
  Future<List<Team>?> download(Function(RequestProgress, bool) callback,
      {Dio? dioTestClient}) async {
    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message: 'Fetching user assigned Teams....',
            status: '',
            percentage: 0),
        false);

    final dataRunUrl = await this.dataRunUrl();

    final response = await HttpClient.get(dataRunUrl,
        database: this.database, dioTestClient: dioTestClient);

    List data = response.body[this.apiResourceName]?.toList();

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
      dataItem['entityScope'] = EntityScope.Assigned.name;
      return Team.fromApi(dataItem);
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

    final String managedTeamsUrl = 'teams/managed?paged=false';

    final managedTeamsResponse = await HttpClient.get(managedTeamsUrl,
        database: this.database, dioTestClient: dioTestClient);

    List managedData =
        managedTeamsResponse.body[this.apiResourceName]?.toList() ?? [];

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                '${managedData.length} ${"managedTeams".toLowerCase()} downloaded successfully',
            status: '',
            percentage: 70),
        false);

    final managedTeams = managedData.map((dataItem) {
      dataItem['dirty'] = false;
      dataItem['entityScope'] = EntityScope.Managed.name;
      return Team.fromApi(dataItem);
    }).toList();

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                '${managedData.length} ${"managedTeams".toLowerCase()} downloaded successfully',
            status: '',
            percentage: 90),
        false);

    await TeamQuery().setData(managedTeams).save();

    // await this.save();

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

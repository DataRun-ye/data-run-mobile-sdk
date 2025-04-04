import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/metadatarun/assignment/entities/d_assignment.entity.dart';
import 'package:d2_remote/modules/metadatarun/assignment/repository/assignment_repository.dart';
import 'package:d2_remote/shared/models/request_progress.model.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
@lazySingleton
class AssignmentQuery extends BaseQuery<Assignment> {
  final AssignmentRepository dataSource;
  String? activity;
  String? warehouse;
  String? team;
  String? orgUnit;

  AssignmentQuery(this.dataSource) : super(dataSource);

  AssignmentQuery byActivity(String activity) {
    this.activity = activity;
    this.where(attribute: 'activity', value: activity);
    return this;
  }

  AssignmentQuery byTeam(String team) {
    this.team = team;
    this.where(attribute: 'team', value: team);
    return this;
  }

  AssignmentQuery byOrgUnit(String orgUnit) {
    this.orgUnit = orgUnit;
    this.where(attribute: 'orgUnit', value: orgUnit);
    return this;
  }

  AssignmentQuery assigned() {
    this.where(attribute: 'scope', value: 'Assigned');
    return this;
  }

  AssignmentQuery managed() {
    this.where(attribute: 'scope', value: 'Managed');
    return this;
  }

  @override
  Future<List<Assignment>?> download(Function(RequestProgress, bool) callback,
      {Dio? dioTestClient}) async {
    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message: 'Fetching user assignments....',
            status: '',
            percentage: 0),
        false);

    final dataRunUrl = await this.dataRunUrl();

    final response = await HttpClient.get(dataRunUrl,
        database: await this.dataSource.database, dioTestClient: dioTestClient);

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
      return Assignment.fromApi(dataItem);
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

    // final activities = data.map((dataItem) {
    //   return Activity.fromJson({...?dataItem['activity'], 'dirty': false});
    // }).toList();
    //
    // await ActivityQuery().setData(activities).save();
    //
    // final orgUnits = data.map((dataItem) {
    //   return OrgUnit.fromJson({
    //     ...?dataItem['orgUnit'],
    //     'scope': EntityScope.Managed.name,
    //     'dirty': false
    //   });
    // }).toList();
    //
    // await OrgUnitQuery().setData(orgUnits).save();
    //
    // final teams = data.map((dataItem) {
    //   return Team.fromApi({
    //     ...?dataItem['team'],
    //     'scope': EntityScope.Managed.name,
    //     'dirty': false
    //   });
    // }).toList();
    //
    // await TeamQuery().setData(teams).save();

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

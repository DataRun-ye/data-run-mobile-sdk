import 'package:d2_remote/modules/metadatarun/activity/queries/d_activity.query.dart';
import 'package:d2_remote/modules/metadatarun/assignment/entities/d_assignment.entity.dart';
import 'package:d2_remote/modules/metadatarun/assignment/queries/d_assignment.query.dart';
import 'package:d2_remote/modules/auth/user/entities/d_user.entity.dart';
import 'package:d2_remote/modules/auth/user/queries/d_user.query.dart';
import 'package:d2_remote/d2_remote.dart';
import 'package:d2_remote/modules/metadatarun/project/queries/d_project.query.dart';
import 'package:d2_remote/modules/metadatarun/teams/queries/d_team.query.dart';
import 'package:d2_remote/modules/metadatarun/warehouse/queries/warehouse.query.dart';
import 'package:d2_remote/modules/datarun/iccm/queries/patient_info.query.dart';
import 'package:d2_remote/modules/datarun/iccm/entities/patient_info.entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../sample/data_run_samples/d_activity.sample.dart';
import '../sample/data_run_samples/patient_info.sample.dart';
import '../sample/data_run_samples/d_assignment.sample.dart';
import '../sample/data_run_samples/d_current_user.sample.dart';
import '../sample/data_run_samples/d_project.sample.dart';
import '../sample/data_run_samples/d_team.sample.dart';
import '../sample/data_run_samples/d_warehouse.sample.dart';
import 'patient_info_sync_test.reflectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  initializeReflectable();
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;

  await D2Remote.initialize(
      databaseFactory: databaseFactoryFfi, databaseName: 'flutter_test');

  var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

  final dio = Dio(BaseOptions());
  final dioAdapter = DioAdapter(dio: dio);

  dUserData['password'] = 'district';
  dUserData['isLoggedIn'] = true;
  dUserData['login'] = 'admin';
  dUserData['baseUrl'] = 'http://localhost:8080';
  DUserQuery userQuery = DUserQuery(database: db);

  final user = DUser.fromApi(dUserData);
  await userQuery.setData(user).save();

  dioAdapter.onGet(
    'http://localhost:8080/api/custom/projects?paging=false&eagerload=true',
        (server) => server.reply(200, dSampleProjects),
  );
  DProjectQuery projectQuery = DProjectQuery(database: db);
  await projectQuery.download((progress, complete) {
    print(progress.message);
  }, dioTestClient: dio);

  dioAdapter.onGet(
    'http://localhost:8080/api/custom/activities?paging=false&eagerload=true',
        (server) => server.reply(200, dSampleActivities),
  );
  final activityQuery = DActivityQuery(database: db);
  await activityQuery.download((progress, complete) {
    print(progress.message);
  }, dioTestClient: dio);

  dioAdapter.onGet(
    'http://localhost:8080/api/custom/warehouses?paging=false&eagerload=true',
        (server) => server.reply(200, dSampleWarehouses),
  );
  final warehouseQuery = WarehouseQuery(database: db);
  await warehouseQuery.download((progress, complete) {
    print(progress.message);
  }, dioTestClient: dio);

  dioAdapter.onGet(
    'http://localhost:8080/api/custom/teams?paging=false&eagerload=true',
        (server) => server.reply(200, dSampleTeams),
  );
  final teamQuery = DTeamQuery(database: db);
  await teamQuery.download((progress, complete) {
    print(progress.message);
  }, dioTestClient: dio);

  dioAdapter.onGet(
    'http://localhost:8080/api/custom/assignments?paging=false&eagerload=true',
        (server) => server.reply(200, dSampleAssignments),
  );
  final assignmentQuery = DAssignmentQuery(database: db);
  await assignmentQuery.download((progress, complete) {
    print(progress.message);
  }, dioTestClient: dio);

  dioAdapter.onGet(
    'http://localhost:8080/api/custom/patientInfo?paging=false&eagerload=true',
        (server) => server.reply(200, dSamplePatientInfo),
  );
  final patientInfoQuery = PatientInfoQuery(database: db);
  await patientInfoQuery.download((progress, complete) {
    print(progress.message);
  }, dioTestClient: dio);

  List<PatientInfo> patientInfo = await D2Remote.iccmModule.patientInfo.get();

  test('should store all incoming patientInfo metadata', () {
    expect(patientInfo.length, 2);
  });
}

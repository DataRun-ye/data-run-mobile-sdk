library d2_remote;

import 'dart:async';

import 'package:d2_remote/core/config/db_security_config.dart';
import 'package:d2_remote/core/config/run_database_config.dart';
import 'package:d2_remote/core/database/database_provider.dart';
import 'package:d2_remote/core/datarun/exception/exception.dart';
import 'package:d2_remote/core/datarun/logging/new_app_logging.dart';
import 'package:d2_remote/core/datarun/utilities/date_helper.dart';
import 'package:d2_remote/di/injection.dart';
import 'package:d2_remote/modules/auth/user/d_user.module.dart';
import 'package:d2_remote/modules/auth/user/entities/d_user.entity.dart';
import 'package:d2_remote/modules/auth/user/queries/d_user.query.dart';
import 'package:d2_remote/modules/datarun/data_value/form_submission.module.dart';
import 'package:d2_remote/modules/datarun/form/form.module.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/authenticated_user.dart';
import 'package:d2_remote/modules/metadatarun/activity/d_activity.module.dart';
import 'package:d2_remote/modules/metadatarun/assignment/d_assignment.module.dart';
import 'package:d2_remote/modules/metadatarun/data_element/data_element.module.dart';
import 'package:d2_remote/modules/metadatarun/option_set/option_set.module.dart';
import 'package:d2_remote/modules/metadatarun/project/d_project.module.dart';
import 'package:d2_remote/modules/metadatarun/teams/d_team.module.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/org_unit.module.dart';
import 'package:d2_remote/shared/utilities/d2_remote.extension.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class D2Remote with D2RemoteMixin {
  static Future<void> initialize(
      {required RunDatabaseConfig config,
      DatabaseFactory? databaseFactory}) async {
    final conf = config.databaseName == null
        ? config.copyWith(databaseName: await D2RemoteMixin.getDatabaseName())
        : config;

    await sdkLocator<DatabaseProvider>().closeDatabase();
    // RunDatabaseConfig(databaseName: '${username}_$uri')
    // Reinitialize the SDK with the new user database
    await setupSdkLocator(config: conf);
  }

  static Future<AuthenticationResult> authenticate(
      {required String username,
      required String password,
      required String url,
      DbSecurityConfig? dbConfig,
      SharedPreferences? sharedPreferenceInstance,
      Duration? timeout,
      bool? inMemory,
      DatabaseFactory? databaseFactory,
      Dio? dioTestClient}) async {
    HttpResponse? userResponse;
    try {
      final timeoutDuration = timeout ?? Duration(seconds: 40);

      userResponse = await HttpClient.get('me',
              baseUrl: url,
              username: username,
              password: password,
              dioTestClient: dioTestClient)
          .timeout(timeoutDuration, onTimeout: () {
        throw TimeoutException('timeout connecting to $url', timeoutDuration);
      });

      if (userResponse.statusCode == 401) {
        throw AuthenticationException('Invalid Credentials',
            url: url,
            errorCode: DErrorCode.authInvalidCredentials,
            httpErrorCode: 401);
      }

      if (userResponse.statusCode == 500) {
        throw AuthenticationException(
            'AuthenticationException: ${userResponse.body.toString().substring(0, 255)}',
            username: username,
            url: url,
            errorCode: DErrorCode.apiError,
            stackTrace: StackTrace.current,
            httpErrorCode: userResponse.statusCode);
      }

      final uri = Uri.parse(url).host;
      final String databaseName = '${username}_$uri';
      await D2RemoteMixin.setDatabaseName(
          databaseName: databaseName,
          sharedPreferenceInstance: sharedPreferenceInstance ??
              await SharedPreferences.getInstance());

      await D2Remote.initialize(
          config: RunDatabaseConfig(
              databaseName: '${username}_$uri',
              inMemory: inMemory ?? false,
              securityConfig: dbConfig),
          databaseFactory: databaseFactory);

      UserQuery userQuery = sdkLocator<UserQuery>();

      Map<String, dynamic> userData = userResponse.body;
      userData['password'] = password;
      userData['isLoggedIn'] = true;
      userData['checkWithServerTime'] = DateHelper.nowUtc();
      userData['username'] = username;
      userData['baseUrl'] = url;
      userData['authTye'] = 'basic';
      userData['dirty'] = true;

      final user = User.fromApi(userData);
      await userQuery.setData(user).save();

      return AuthenticationResult(success: true, sessionUser: user);
    } on TimeoutException catch (timeoutException) {
      throw AuthenticationException(
          'Authentication Timeout connecting to server',
          username: username,
          cause: timeoutException,
          url: url,
          errorCode: DErrorCode.networkTimeout,
          stackTrace: StackTrace.current,
          httpErrorCode: userResponse?.statusCode);
    } catch (e) {
      logError('$e', data: {"username": username, "url": url});
      rethrow;
    }
  }

  static Future<bool> logOut(
      {SharedPreferences? sharedPreferenceInstance}) async {
    WidgetsFlutterBinding.ensureInitialized();
    bool logOutSuccess = false;
    try {
      final currentUserMap = {
        ...?(await D2Remote.userModule.user.getOne())?.toJson(),
        'isLoggedIn': false,
        'dirty': true
      };

      await D2Remote.userModule.user
          .setData(User.fromJson(currentUserMap))
          .save();

      // nmc
      SharedPreferences prefs =
          sharedPreferenceInstance ?? await SharedPreferences.getInstance();
      prefs.remove(D2RemoteMixin.currentDatabaseNameKey);
      await sdkLocator<DatabaseProvider>().closeDatabase();
      logOutSuccess = true;
    } catch (e) {}
    return logOutSuccess;
  }

  static UserModule get userModule => sdkLocator<UserModule>();

  static DataElementModule get dataElementModule =>
      sdkLocator<DataElementModule>();

  static OptionSetModule get optionSetModule => sdkLocator<OptionSetModule>();

  static OrgUnitModule get organisationUnitModuleD =>
      sdkLocator<OrgUnitModule>();

  static ProjectModule get projectModuleD => sdkLocator<ProjectModule>();

  static ActivityModule get activityModuleD => sdkLocator<ActivityModule>();

  static AssignmentModule get assignmentModuleD =>
      sdkLocator<AssignmentModule>();

  static FormModule get formModule => sdkLocator<FormModule>();

  static FormSubmissionModule get formSubmissionModule =>
      sdkLocator<FormSubmissionModule>();

  static TeamModule get teamModuleD => sdkLocator<TeamModule>();
}
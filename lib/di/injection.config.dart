// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:d2_remote/core/database/database_provider.dart' as _i849;
import 'package:d2_remote/modules/auth/user/d_user.module.dart' as _i1020;
import 'package:d2_remote/modules/auth/user/queries/d_user.query.dart' as _i679;
import 'package:d2_remote/modules/auth/user/queries/d_user_authority.query.dart'
    as _i303;
import 'package:d2_remote/modules/auth/user/repository/user_authority_repository.dart'
    as _i724;
import 'package:d2_remote/modules/auth/user/repository/user_repository.dart'
    as _i897;
import 'package:d2_remote/modules/datarun/data_value/form_submission.module.dart'
    as _i18;
import 'package:d2_remote/modules/datarun/data_value/queries/data_form_submission.query.dart'
    as _i1072;
import 'package:d2_remote/modules/datarun/data_value/queries/data_value.query.dart'
    as _i586;
import 'package:d2_remote/modules/datarun/data_value/queries/repeated_instance.query.dart'
    as _i812;
import 'package:d2_remote/modules/datarun/data_value/repository/data_value_repository.dart'
    as _i1058;
import 'package:d2_remote/modules/datarun/data_value/repository/repeat_instance_repository.dart'
    as _i175;
import 'package:d2_remote/modules/datarun/data_value/repository/submission_repository.dart'
    as _i502;
import 'package:d2_remote/modules/datarun/form/form.module.dart' as _i211;
import 'package:d2_remote/modules/datarun/form/queries/form_template.query.dart'
    as _i550;
import 'package:d2_remote/modules/datarun/form/queries/form_version.query.dart'
    as _i683;
import 'package:d2_remote/modules/datarun/form/queries/metadata_schema.query.dart'
    as _i345;
import 'package:d2_remote/modules/datarun/form/queries/metadata_submission.query.dart'
    as _i1048;
import 'package:d2_remote/modules/datarun/form/queries/metadata_submission_update.query.dart'
    as _i1057;
import 'package:d2_remote/modules/datarun/form/repository/form_template_repository.dart'
    as _i302;
import 'package:d2_remote/modules/datarun/form/repository/form_version_repository.dart'
    as _i34;
import 'package:d2_remote/modules/datarun/form/repository/metadata_schema_repository.dart'
    as _i559;
import 'package:d2_remote/modules/datarun/form/repository/metadata_submission_repository.dart'
    as _i988;
import 'package:d2_remote/modules/datarun/form/repository/metadata_submission_update_repository.dart'
    as _i280;
import 'package:d2_remote/modules/metadatarun/activity/d_activity.module.dart'
    as _i1012;
import 'package:d2_remote/modules/metadatarun/activity/queries/d_activity.query.dart'
    as _i958;
import 'package:d2_remote/modules/metadatarun/activity/repository/activity_repository.dart'
    as _i195;
import 'package:d2_remote/modules/metadatarun/assignment/d_assignment.module.dart'
    as _i916;
import 'package:d2_remote/modules/metadatarun/assignment/queries/d_assignment.query.dart'
    as _i439;
import 'package:d2_remote/modules/metadatarun/assignment/repository/assignment_repository.dart'
    as _i141;
import 'package:d2_remote/modules/metadatarun/data_element/data_element.module.dart'
    as _i84;
import 'package:d2_remote/modules/metadatarun/data_element/queries/data_element.query.dart'
    as _i413;
import 'package:d2_remote/modules/metadatarun/data_element/repository/data_element_repository.dart'
    as _i672;
import 'package:d2_remote/modules/metadatarun/metadatarun.dart' as _i813;
import 'package:d2_remote/modules/metadatarun/option_set/option_set.module.dart'
    as _i605;
import 'package:d2_remote/modules/metadatarun/option_set/queries/option_set.query.dart'
    as _i220;
import 'package:d2_remote/modules/metadatarun/option_set/repository/option_set_repository.dart'
    as _i242;
import 'package:d2_remote/modules/metadatarun/org_unit/org_unit.module.dart'
    as _i279;
import 'package:d2_remote/modules/metadatarun/org_unit/queries/org_unit.query.dart'
    as _i994;
import 'package:d2_remote/modules/metadatarun/org_unit/queries/org_unit_level.query.dart'
    as _i12;
import 'package:d2_remote/modules/metadatarun/org_unit/repository/org_unit_level_repository.dart'
    as _i977;
import 'package:d2_remote/modules/metadatarun/org_unit/repository/org_unit_repository.dart'
    as _i131;
import 'package:d2_remote/modules/metadatarun/project/d_project.module.dart'
    as _i1020;
import 'package:d2_remote/modules/metadatarun/project/queries/d_project.query.dart'
    as _i542;
import 'package:d2_remote/modules/metadatarun/project/repository/project_repository.dart'
    as _i956;
import 'package:d2_remote/modules/metadatarun/teams/d_team.module.dart'
    as _i323;
import 'package:d2_remote/modules/metadatarun/teams/queries/d_team.query.dart'
    as _i630;
import 'package:d2_remote/modules/metadatarun/teams/repository/team_repository.dart'
    as _i320;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initD2RemoteGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i724.UserAuthorityRepository>(
      () => _i724.UserAuthorityRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i897.UserRepository>(
      () => _i897.UserRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i1058.DataValueRepository>(
      () => _i1058.DataValueRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i175.RepeatInstanceRepository>(
      () => _i175.RepeatInstanceRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i502.SubmissionRepository>(
      () => _i502.SubmissionRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i302.FormTemplateRepository>(
      () => _i302.FormTemplateRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i34.FormVersionRepository>(
      () => _i34.FormVersionRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i195.ActivityRepository>(
      () => _i195.ActivityRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i141.AssignmentRepository>(
      () => _i141.AssignmentRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i672.DataElementRepository>(
      () => _i672.DataElementRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i242.OptionSetRepository>(
      () => _i242.OptionSetRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i977.OrgUnitLevelRepository>(
      () => _i977.OrgUnitLevelRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i131.OrgUnitRepository>(
      () => _i131.OrgUnitRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i956.ProjectRepository>(
      () => _i956.ProjectRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i320.TeamRepository>(
      () => _i320.TeamRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i559.MetadataSchemaRepository>(
      () => _i559.MetadataSchemaRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i280.MetadataSubmissionUpdateRepository>(() =>
      _i280.MetadataSubmissionUpdateRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i988.MetadataSubmissionRepository>(
      () => _i988.MetadataSubmissionRepository(gh<_i849.DatabaseProvider>()));
  gh.lazySingleton<_i812.RepeatInstanceQuery>(
      () => _i812.RepeatInstanceQuery(gh<_i175.RepeatInstanceRepository>()));
  gh.lazySingleton<_i550.FormTemplateQuery>(() => _i550.FormTemplateQuery(
        gh<_i302.FormTemplateRepository>(),
        gh<_i34.FormVersionRepository>(),
      ));
  gh.lazySingleton<_i413.DataElementQuery>(
      () => _i413.DataElementQuery(gh<_i672.DataElementRepository>()));
  await gh.lazySingletonAsync<_i84.DataElementModule>(
    () {
      final i = _i84.DataElementModule(gh<_i413.DataElementQuery>());
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  gh.lazySingleton<_i679.UserQuery>(() => _i679.UserQuery(
        gh<_i897.UserRepository>(),
        gh<_i724.UserAuthorityRepository>(),
      ));
  gh.lazySingleton<_i1048.MetadataSubmissionQuery>(() =>
      _i1048.MetadataSubmissionQuery(gh<_i988.MetadataSubmissionRepository>()));
  gh.lazySingleton<_i439.AssignmentQuery>(
      () => _i439.AssignmentQuery(gh<_i141.AssignmentRepository>()));
  gh.lazySingleton<_i220.OptionSetQuery>(
      () => _i220.OptionSetQuery(gh<_i242.OptionSetRepository>()));
  await gh.lazySingletonAsync<_i916.AssignmentModule>(
    () {
      final i = _i916.AssignmentModule(gh<_i439.AssignmentQuery>());
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  gh.lazySingleton<_i1072.DataFormSubmissionQuery>(
      () => _i1072.DataFormSubmissionQuery(gh<_i502.SubmissionRepository>()));
  await gh.lazySingletonAsync<_i605.OptionSetModule>(
    () {
      final i = _i605.OptionSetModule(gh<_i220.OptionSetQuery>());
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  gh.lazySingleton<_i630.TeamQuery>(
      () => _i630.TeamQuery(gh<_i320.TeamRepository>()));
  gh.lazySingleton<_i12.OrgUnitLevelQuery>(
      () => _i12.OrgUnitLevelQuery(gh<_i977.OrgUnitLevelRepository>()));
  await gh.lazySingletonAsync<_i323.TeamModule>(
    () {
      final i = _i323.TeamModule(gh<_i813.TeamQuery>());
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  gh.lazySingleton<_i958.ActivityQuery>(() => _i958.ActivityQuery(
        gh<_i195.ActivityRepository>(),
        gh<_i302.FormTemplateRepository>(),
      ));
  gh.lazySingleton<_i683.FormVersionQuery>(
      () => _i683.FormVersionQuery(gh<_i34.FormVersionRepository>()));
  gh.lazySingleton<_i303.UserAuthorityQuery>(
      () => _i303.UserAuthorityQuery(gh<_i724.UserAuthorityRepository>()));
  gh.lazySingleton<_i345.MetadataSchemaQuery>(
      () => _i345.MetadataSchemaQuery(gh<_i559.MetadataSchemaRepository>()));
  gh.lazySingleton<_i994.OrgUnitQuery>(
      () => _i994.OrgUnitQuery(gh<_i131.OrgUnitRepository>()));
  await gh.lazySingletonAsync<_i279.OrgUnitModule>(
    () {
      final i = _i279.OrgUnitModule(
        gh<_i994.OrgUnitQuery>(),
        gh<_i12.OrgUnitLevelQuery>(),
      );
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  gh.lazySingleton<_i542.ProjectQuery>(
      () => _i542.ProjectQuery(gh<_i956.ProjectRepository>()));
  gh.lazySingleton<_i1057.MetadataSubmissionUpdateQuery>(() =>
      _i1057.MetadataSubmissionUpdateQuery(
          gh<_i280.MetadataSubmissionUpdateRepository>()));
  gh.lazySingleton<_i586.DataValueQuery>(
      () => _i586.DataValueQuery(gh<_i1058.DataValueRepository>()));
  await gh.lazySingletonAsync<_i211.FormModule>(
    () {
      final i = _i211.FormModule(
        gh<_i550.FormTemplateQuery>(),
        gh<_i683.FormVersionQuery>(),
        gh<_i1048.MetadataSubmissionQuery>(),
        gh<_i1057.MetadataSubmissionUpdateQuery>(),
      );
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  await gh.lazySingletonAsync<_i18.FormSubmissionModule>(
    () {
      final i = _i18.FormSubmissionModule(
        gh<_i586.DataValueQuery>(),
        gh<_i812.RepeatInstanceQuery>(),
        gh<_i1072.DataFormSubmissionQuery>(),
      );
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  await gh.lazySingletonAsync<_i1012.ActivityModule>(
    () {
      final i = _i1012.ActivityModule(gh<_i958.ActivityQuery>());
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  await gh.lazySingletonAsync<_i1020.UserModule>(
    () {
      final i = _i1020.UserModule(
        gh<_i679.UserQuery>(),
        gh<_i303.UserAuthorityQuery>(),
      );
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  await gh.lazySingletonAsync<_i1020.ProjectModule>(
    () {
      final i = _i1020.ProjectModule(gh<_i542.ProjectQuery>());
      return i.initialize().then((_) => i);
    },
    preResolve: true,
  );
  return getIt;
}

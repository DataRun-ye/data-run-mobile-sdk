import 'package:d2_remote/modules/metadatarun/teams/queries/d_team.query.dart';

class TeamModule {
  static createTables() async {
    await TeamQuery().createTable();
  }

  TeamQuery get team => TeamQuery();
}

enum TeamType {
  ITNS_DISTRIBUTION,
  ITNS_WAREHOUSE,
  IRS_DISTRIBUTION,
  IRS_WAREHOUSE,
  CHV_PATIENTS,
  UNKNOWN
}

class TeamTypeUtil {
  static TeamType getTeamType(String? fieldType) {
    switch (fieldType) {
      case 'ITNS_DISTRIBUTION':
        return TeamType.ITNS_DISTRIBUTION;

      case 'ITNS_WAREHOUSE':
        return TeamType.ITNS_WAREHOUSE;

      case 'IRS_DISTRIBUTION':
        return TeamType.IRS_DISTRIBUTION;

      case 'IRS_WAREHOUSE':
        return TeamType.IRS_WAREHOUSE;

      case 'CHV_PATIENTS':
        return TeamType.CHV_PATIENTS;
      default:
        return TeamType.UNKNOWN;
    }
  }
}

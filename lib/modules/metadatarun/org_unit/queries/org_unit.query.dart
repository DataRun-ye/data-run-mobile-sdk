import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/entities/org_unit.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class OrgUnitQuery extends BaseQuery<OrgUnit> {
  OrgUnitQuery({Database? database}) : super(database: database);

// Download Tree Nodes entities
// Future<List<OrgUnit>> downloadOrgUnits(Function(RequestProgress, bool) callback,
//     {Dio? dioTestClient}) async {
//   // Step 1: Fetch accessible orgUnits.
//   callback(RequestProgress(
//       resourceName: this.apiResourceName!,
//       message: 'Fetching accessible OrgUnits...',
//       status: '',
//       percentage: 0
//   ), false);
//
//   final dataRunUrl = await this.dataRunUrl();
//
//   final response = await HttpClient.get(dataRunUrl, database: database, dioTestClient: dioTestClient);
//   List data = response.body[apiResourceName]?.toList() ?? [];
//
//   callback(RequestProgress(
//       resourceName: this.apiResourceName!,
//       message: '${data.length} OrgUnits downloaded.',
//       status: '',
//       percentage: 40
//   ), false);
//
//   // Step 2: Parse accessible OrgUnits.
//   List<OrgUnit> accessibleOrgUnits = data.map((dataItem) {
//     dataItem['dirty'] = false;
//     dataItem['entityScope'] = EntityScope.Assigned.name;
//     return OrgUnit.fromJson(dataItem);
//   }).toList();
//
//   // Step 3: Extract ancestors/parents from accessible orgUnits.
//   List<OrgUnit> extractedOrgUnits = [];
//   for (var orgUnit in accessibleOrgUnits) {
//     // Process the "ancestors" array if available.
//     if (orgUnit.ancestors != null) {
//       for (var ancestorData in orgUnit.ancestors!) {
//         OrgUnit ancestor = OrgUnit.fromJson(ancestorData);
//         // Deduplicate: Only add if not already present.
//         bool exists = accessibleOrgUnits.any((o) => o.uid == ancestor.uid) ||
//             extractedOrgUnits.any((o) => o.uid == ancestor.uid);
//         if (!exists) {
//           extractedOrgUnits.add(ancestor);
//         }
//       }
//     }
//     // Also check the immediate parent.
//     if (orgUnit.parentUid != null) {
//       bool exists = accessibleOrgUnits.any((o) => o.uid == orgUnit.parentUid) ||
//           extractedOrgUnits.any((o) => o.uid == orgUnit.parentUid);
//       if (!exists) {
//         // Create a minimal OrgUnit for parent (you may have more logic to fill in details).
//         OrgUnit parentOrgUnit = OrgUnit(
//           uid: orgUnit.parentUid!,
//           name: 'Parent', // Use a fallback or fetch details if available.
//           parentUid: null,
//           path: '', // Calculate or leave empty.
//           level: orgUnit.level - 1,
//         );
//         extractedOrgUnits.add(parentOrgUnit);
//       }
//     }
//   }
//
//   final db = await database;
//   // Step 4: Persist data in a transaction.
//   await db!.transaction((txn) async {
//     // Save accessible OrgUnits.
//     await saveAccessibleOrgUnits(txn, accessibleOrgUnits);
//     // Save extracted OrgUnits.
//     await saveExtractedOrgUnits(txn, extractedOrgUnits);
//   });
//
//   callback(RequestProgress(
//       resourceName: this.apiResourceName!,
//       message: '${accessibleOrgUnits.length + extractedOrgUnits.length} OrgUnits saved successfully.',
//       status: '',
//       percentage: 100
//   ), true);
//
//   // Optionally, merge both lists or return a combined view.
//   return accessibleOrgUnits;
// }
}

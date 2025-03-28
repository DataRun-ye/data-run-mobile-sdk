import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun_shared/utilities/entity_scope.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:d2_remote/shared/entities/identifiable_tree_node.entity.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'orgUnit', apiResourceName: 'orgUnits')
class OrgUnit extends IdentifiableTreeNode {
  @legacy.Column(nullable: true)
  Object? geometry;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  EntityScope? scope;

  OrgUnit(
      {required String id,
      required String name,
      String? displayName,
      String? code,
      required String? path,
      String? parent,
      required Map<String, String> label,
      List<OrgUnit>? ancestors,
      String? lastModifiedDate,
      String? createdDate,
      this.scope,
      this.geometry,
      required dirty})
      : super(
            id: id,
            // uid: uid,
            code: code,
            name: name,
            displayName: displayName,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate,
            label: label,
            ancestors: ancestors,
            path: path,
            parent: parent,
            dirty: dirty);

  factory OrgUnit.fromJson(Map<String, dynamic> json) {
    final scope = EntityScope.getType(json['entityScope'] ?? json['scope']);

    final parent = json['parent'];

    final ancestors = json['ancestors'] != null
        ? (parseDynamicJson(json['ancestors']) as List)
            .map((ancestor) => OrgUnit.fromJson(ancestor))
            .toList()
        : null;

    return OrgUnit(
        id: json['uid'] ?? json['id'].toString(),
        code: json['code'],
        name: json['name'],
        path: json['path'],
        displayName: json['displayName'],
        ancestors: ancestors,
        parent: parent != null
            ? parent is String
                ? parent
                : (parent['uid'] ?? parent['id'])
            : null,
        label: json['label'] != null
            ? Map<String, String>.from(json['label'] is String
                ? jsonDecode(json['label'])
                : json['label'])
            : {"en": json['name']},
        // geometry: geometry,
        geometry: json['geometry']?.toString() ?? null,
        createdDate: json['createdDate'],
        lastModifiedDate: json['lastModifiedDate'],
        scope: scope,
        dirty: json['dirty'] ?? false);
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'uid': id,
      'code': code,
      'name': name,
      'path': path,
      'parent': parent,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'displayName': displayName,
      'label': jsonEncode(label),
      'ancestors': ancestors != null
          ? jsonEncode(ancestors!.map((ancestor) => ancestor.toJson()).toList())
          : null,

      'scope': this.scope?.name,
      'geometry': this.geometry,
      // 'geometry': this.geometry != null
      //     ? jsonEncode(this.geometry?.geometryData)
      //     : null,
      'dirty': dirty,
    };

    if (this.parent != null) {
      data['parent'] = this.parent;
    }

    return data;
  }
}

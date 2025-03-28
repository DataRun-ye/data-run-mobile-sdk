import 'dart:convert';

import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@legacy.AnnotationReflectable
class IdentifiableTreeNode extends IdentifiableEntity {
  @legacy.Column(nullable: true)
  String? path;

  @legacy.Column(nullable: false, type: legacy.ColumnType.TEXT)
  Map<String, String> label;

  @legacy.Column(name: 'parent', nullable: true)
  String? parent;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  List<IdentifiableTreeNode>? ancestors;

  IdentifiableTreeNode(
      {required String id,
      required String name,
      String? displayName,
      String? code,
      String? lastModifiedDate,
      String? createdDate,
      required this.path,
      required this.label,
      this.parent,
      this.ancestors,
      required dirty})
      : super(
            id: id,
            name: name,
            code: code,
            dirty: dirty,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate);

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
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
      'dirty': dirty,
    };

    if (this.parent != null) {
      data['parent'] = this.parent;
    }

    return data;
  }
}

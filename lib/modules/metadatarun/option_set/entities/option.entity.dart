import 'dart:convert';

import 'package:d2_remote/core/annotations/column.annotation.dart';
import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:d2_remote/modules/metadatarun/option_set/entities/option_set.entity.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'option', apiResourceName: 'options')
class Option extends IdentifiableEntity {
  @legacy.Column(nullable: false, type: ColumnType.INTEGER)
  final int sortOrder;

  @legacy.Column(type: ColumnType.TEXT, nullable: true)
  final String? description;

  @legacy.ManyToOne(table: OptionSet, joinColumnName: 'optionSet')
  dynamic optionSet;

  @legacy.Column(type: ColumnType.TEXT, nullable: true)
  final String? filterExpression;

  @legacy.Column(nullable: true, type: legacy.ColumnType.TEXT)
  final Map<String, String> label = {};

  @legacy.Column(type: ColumnType.TEXT, nullable: true)
  final Map<String, dynamic>? properties;

  Option(
      {required String id,
      required String name,
      String? code,
      String? displayName,
      Map<String, String> label = const {},
      required this.sortOrder,
      required this.optionSet,
      this.description,
      this.filterExpression,
      this.properties,
      String? createdDate,
      String? lastModifiedDate,
      required bool dirty})
      : super(
            id: id,
            name: name,
            code: code,
            displayName: displayName,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate,
            dirty: dirty) {
    this.label.addAll(label);
  }

  factory Option.fromJson(Map<String, dynamic> jsonData) {
    final properties = jsonData['properties'] != null
        ? Map<String, dynamic>.from(parseDynamicJson(jsonData['properties']))
        : null;
    final label = jsonData['label'] != null
        ? Map<String, String>.from(parseDynamicJson(jsonData['label']))
        : <String, String>{"ar": jsonData['name']};
    return Option(
        id: jsonData['id'],
        name: jsonData['name'],
        code: jsonData['code'],
        optionSet: jsonData['optionSet'],
        displayName: jsonData['displayName'],
        description: jsonData['description'],
        sortOrder: jsonData['sortOrder'] ?? jsonData['order'] ?? 0,
        filterExpression: jsonData['filterExpression'],
        label: label,
        properties: properties,
        createdDate: jsonData['createdDate'],
        lastModifiedDate: jsonData['lastModifiedDate'],
        dirty: jsonData['dirty'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': id,
      'code': code,
      'name': name,
      'optionSet': optionSet,
      'sortOrder': sortOrder,
      'displayName': displayName,
      'description': description,
      'label': jsonEncode(label),
      'filterExpression': filterExpression,
      'properties': properties != null ? jsonEncode(properties) : null,
      'createdDate': this.createdDate,
      'lastModifiedDate': this.lastModifiedDate,
      'dirty': dirty,
    };
  }

  List<String> get filterExpressionDependencies {
    final fieldPattern = RegExp(r'#\{(.*?)\}');

    return filterExpression != null
        ? fieldPattern
            .allMatches(filterExpression!)
            .map((match) => match.group(1)!)
            .toSet()
            .toList()
        : [];
  }

  String? get evalFilterExpression {
    return filterExpression?.replaceAll("#{", "").replaceAll("}", "");
  }

  Map<String, dynamic> toContext() {
    return {
      'code': code,
      'name': name,
      'label': label,
      // 'listName': listName,
      ...?properties,
      'filterExpression': evalFilterExpression,
      'filterExpressionDependencies': filterExpressionDependencies,
      'order': sortOrder,
    };
  }
}

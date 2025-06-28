import 'dart:convert';

import 'package:d2_remote/core/annotations/column.annotation.dart';
import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/modules/metadatarun/option_set/entities/option_set.entity.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@legacy.AnnotationReflectable
@legacy.Entity(tableName: 'option', apiResourceName: 'options')
class Option extends IdentifiableEntity {
  @legacy.Column(nullable: true, type: ColumnType.INTEGER)
  final int? sortOrder;

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
      // required this.listName,
      required this.sortOrder,
      required this.optionSet,
      this.description,
      this.filterExpression,
      this.properties,
      required bool dirty})
      : super(
            id: id,
            name: name,
            code: code,
            displayName: displayName,
            dirty: dirty) {
    label.addAll(label);
  }

  factory Option.fromJson(Map<String, dynamic> jsonData) {
    final label = jsonData['label'] != null
        ? Map<String, String>.from(jsonData['label'] is String
            ? jsonDecode(jsonData['label'])
            : jsonData['label'])
        : <String, String>{"ar": jsonData['name'], "en": jsonData['name']};

    final properties = jsonData['properties'] != null
        ? Map<String, dynamic>.from(jsonData['properties'] is String
            ? jsonDecode(jsonData['properties'])
            : jsonData['properties'])
        : <String, dynamic>{};

    return Option(
        id: '${jsonData['optionSet']}_${jsonData['name']}',
        name: jsonData['name'],
        code: jsonData['code'],
        optionSet: jsonData['optionSet'],
        displayName: jsonData['displayName'],
        description: jsonData['description'],
        label: jsonData['label'] != null
            ? Map<String, String>.from(jsonData['label'] is String
            ? jsonDecode(jsonData['label'])
            : jsonData['label'])
            : {"en": jsonData['name']},
        sortOrder: jsonData['order'] ?? 0,
        filterExpression: jsonData['filterExpression'],
        properties: properties,
        dirty: jsonData['dirty']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'optionSet': optionSet,
      'order': sortOrder,
      'displayName': displayName,
      'description': description,
      'label': label,
      'filterExpression': filterExpression,
      'properties': properties,
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

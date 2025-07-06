import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/shared/entities/base.entity.dart';
import 'package:d2_remote/shared/utilities/merge_mode.util.dart';
import 'package:d2_remote/shared/utilities/query_filter.util.dart';
import 'package:d2_remote/shared/utilities/sort_order.util.dart';
import 'package:sqflite/sqflite.dart';

/// An abstract base repository class that defines common operations
/// for managing entities of type [T] in a SQLite database.
///
/// The class provides methods to create, read, update, and delete entities.
/// It also includes utilities for handling relationships and sanitizing data.
abstract class BaseRepositoryD<T extends BaseEntity> {
  /// A list of columns representing the properties of the entity.
  List<Column> get columns;

  /// A list of columns that represent one-to-many relationships.
  List<Column> get oneToManyColumns;

  /// The entity definition for this repository.
  Entity get entity;

  /// The SQL query used to create the table for this entity.
  String get createQuery;

  /// Gets the database instance.
  Future<Database> get database;

  /// Creates the table for this entity in the database.
  ///
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns `1` on success.
  Future<dynamic> create({Database database});

  /// Counts the number of entities in the database.
  ///
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the number of entities in the database.
  Future<int> count({Database database});

  Future<List<T>> findAll(
      {List<QueryFilter>? filters,
      List<String>? fields,
      Map<String, SortOrder>? sortOrder,
      Database? database,
      List<ColumnRelation>? relations});

  /// Finds entities in the database matching the given [filters].
  ///
  /// Optionally, a list of [fields] to be returned and a [sortOrder] can be
  /// specified. If a [database] instance is provided, it will be used;
  /// otherwise, the default database instance will be used.
  ///
  /// Returns a list of entities matching the criteria.
  Future<List<T>> find(
      {String? id,
      List<QueryFilter>? filters,
      List<String>? fields,
      Map<String, SortOrder>? sortOrder,
      Database? database});

  /// Finds an entity by its [id].
  ///
  /// Optionally, a list of [fields] to be returned can be specified.
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the entity with the given [id], or `null` if no such entity exists.
  Future<T?> findById(
      {required String id, List<String>? fields, Database? database});

  /// Inserts a single [entity] into the database.
  ///
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the number of rows affected.
  Future<int> insertOne({required T entity, Database? database});

  /// Inserts multiple [entities] into the database.
  ///
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the number of rows affected.
  Future<int> insertMany({required List<T> entities, Database? database});

  /// Updates a single [entity] in the database.
  ///
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the number of rows affected.
  Future<int> updateOne({required T entity, Database database});

  /// Updates multiple [entities] in the database.
  ///
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the number of rows affected.
  Future<int> updateMany({required List<T> entities, Database database});

  /// Saves a single [entity] in the database.
  ///
  /// The [mergeMode] determines how existing data is merged with new data.
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  ///
  ///
  /// Returns the number of rows affected.
  Future<int> saveOne(
      {required T entity, Database database, required MergeMode mergeMode});

  /// Saves multiple [entities] in the database.
  ///
  /// The [mergeMode] determines how existing data is merged with new data.
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the number of rows affected.
  Future<int> saveMany(
      {required List<T> entities,
      Database database,
      required MergeMode mergeMode});

  /// Deletes an entity by its [id].
  ///
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the number of rows affected.
  Future<int> deleteById({required String id, Database database});

  /// Deletes entities by their [ids].
  ///
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the number of rows affected.
  Future<int> deleteByIds({required List<String> ids, Database database});

  /// Deletes all entities in the database.
  ///
  /// If a [database] instance is provided, it will be used; otherwise, the
  /// default database instance will be used.
  ///
  /// Returns the number of rows affected.
  Future<int> deleteAll({Database database});

  /// Sanitizes the incoming [entity] data to ensure it matches the [columns]
  /// structure of the database.
  ///
  /// - Iterates through each column.
  ///   - Handles boolean data types by converting true to 1 and false to 0.
  ///   - Handles relations (except OneToMany):
  ///     - If a relation exists and it's not OneToMany, it retrieves the related entity's value using the `attributeName` and stores the value from the `referencedColumn` of the related entity.
  ///   - Handles other data types:
  ///     - If the entity's attribute value is a list, it converts it to a string.
  ///     - Otherwise, it assigns the entity's attribute value directly to the corresponding column name in the data map.
  ///
  /// Returns a map containing the sanitized entity data..
  Map<String, dynamic> sanitizeIncomingData(
      {required Map<String, dynamic> entity, required List<Column> columns});
}

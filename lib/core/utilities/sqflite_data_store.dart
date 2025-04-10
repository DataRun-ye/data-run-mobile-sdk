import 'dart:async';

import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/core/database/database_provider.dart';
import 'package:d2_remote/core/datarun/utilities/date_helper.dart';
import 'package:d2_remote/core/datarun/utilities/repository_d.dart';
import 'package:d2_remote/core/utilities/data_store_util.dart';
import 'package:d2_remote/shared/entities/base.entity.dart';
import 'package:d2_remote/shared/utilities/merge_mode.util.dart';
import 'package:d2_remote/shared/utilities/query_filter.util.dart';
import 'package:d2_remote/shared/utilities/query_filter_condition.util.dart';
import 'package:d2_remote/shared/utilities/sort_order.util.dart';
import 'package:queue/queue.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/utilities/save_option.util.dart';
import 'query_expression.dart';

class DataStore<T extends BaseEntity> extends BaseDataStore<T> {
  final DatabaseProvider _dbProvider;

  DataStore(this._dbProvider);

  FutureOr<Database> get database => _dbProvider.database;

  @override
  Future<List<T>> findAll(
      {List<QueryFilter>? filters,
      List<String>? fields,
      Map<String, SortOrder>? sortOrder,
      Database? database,
      List<ColumnRelation>? relations,
      // NMC
      LogicalOperator operator = LogicalOperator.AND,
      int? limit,
      int? offset}) async {
    final Database db = database != null ? database : await this.database;

    return this.find(
        filters: filters,
        fields: fields,
        sortOrder: sortOrder,
        database: db,
        relations: relations,
        operator: operator,
        offset: offset,
        limit: limit);
  }

  @override
  Future<List<T>> find(
      {String? id,
      List<QueryFilter>? filters,
      List<String>? fields,
      Map<String, SortOrder>? sortOrder,
      Database? database,
      List<ColumnRelation>? relations,
      // NMC
      LogicalOperator operator = LogicalOperator.AND,
      int? limit,
      int? offset}) async {
    final Database db = database != null ? database : await this.database;

    if (id != null) {
      final queryResult = await db.query(this.entity.tableName,
          where: 'id = ?', whereArgs: [id], columns: fields);

      final relationResults = await this.findRelations(
          database: db,
          relations: relations,
          data: queryResult.length > 0 ? queryResult[0] : null);

      final dataResult = queryResult.map((result) {
        Map<String, dynamic> resultMap = {...result};

        this.columns.forEach((column) {
          final key = column.name;
          final relationElement =
              (relationResults != null ? relationResults : [])
                  .where((relationResult) => relationResult['attribute'] == key)
                  .toList();

          if (relationElement.length > 0) {
            resultMap[relationElement[0]['attribute']] =
                relationElement[0]['data'];
          } else {
            resultMap[key as String] = result[key];
          }
        });

        return getObject<T>(resultMap);
      }).toList();

      return dataResult;
    }

    final String? whereParameters =
        QueryFilter.getWhereParameters(this.columns, filters, operator: operator);
    final String? orderParameters =
        SortOrderUtil.getSortOrderParameters(sortOrder);

    if (whereParameters == null) {
      final dataResults = (await db.query(this.entity.tableName,
          orderBy: orderParameters, columns: fields));

      final List<String> dataIds =
          dataResults.map((dataResult) => dataResult['id'].toString()).toList();

      final relationData = await this.findRelationByParent(
          relations: relations as List<ColumnRelation>,
          dataIds: dataIds,
          orderParameters: orderParameters,
          database: db);

      return dataResults.map((queryResult) {
        Map<String, dynamic> resultMap = {...queryResult};

        (relationData ?? []).forEach((relationDataItem) {
          final availableRelationData = (relationDataItem['data'] ?? [])
              .where((relationItem) =>
                  relationItem[relationDataItem['referencedColumn']] ==
                  queryResult['id'])
              .toList();
          resultMap[relationDataItem['relation']] = availableRelationData;
        });

        return getObject<T>(resultMap);
      }).toList();
    }

    return findWhere(
        database: db,
        whereParameters: whereParameters,
        orderParameters: orderParameters,
        relations: relations);
  }

  Future<List?> findRelations(
      {Database? database,
      List<ColumnRelation>? relations,
      dynamic data}) async {
    if (relations == null || relations.length == 0 || data == null) {
      return null;
    }

    return Future.wait(relations.map((relation) async {
      final referencedValue = data[
          relation.relationType == RelationType.OneToMany
              ? relation.primaryKey
              : relation.attributeName];
      final Database db = database != null ? database : await this.database;

      final whereParameters =
          '${relation.referencedColumn} = "$referencedValue"';

      final relationResult = (await db.query(
              relation.referencedEntity?.tableName as String,
              where: whereParameters))
          .toList();

      Map<String, dynamic> resultMap = {};
      resultMap['attribute'] = relation.attributeName;

      final dataResult = (relation.relationType == RelationType.ManyToOne
          ? relationResult.length > 0
              ? relationResult[0]
              : null
          : relationResult);
      resultMap['data'] = dataResult;

      return resultMap;
    }));
  }

  Future<List?> findRelationByParent(
      {required List<ColumnRelation> relations,
      required List<String> dataIds,
      Database? database,
      String? orderParameters}) async {
    return Future.wait((relations).map((relation) async {
      final filters = [
        QueryFilter(
            attribute: relation.referencedColumn as String,
            condition: QueryCondition.In,
            value: dataIds)
      ];

      final String? whereParameters = QueryFilter.getWhereParameters(
          relation.referencedEntityColumns as List<Column>, filters);

      final Database db = database != null ? database : await this.database;

      final newItem = await findWhereInRelation(
          database: db,
          entity: relation.referencedEntity as Entity,
          columns: relation.referencedEntityColumns as List<Column>,
          whereParameters: whereParameters,
          orderParameters: orderParameters);

      return {
        "relation": relation.attributeName,
        "referencedColumn": relation.referencedColumn,
        "data": newItem
      };
    }));
  }

  Future<List> findWhereInRelation({
    Database? database,
    required Entity entity,
    required List<Column> columns,
    String? whereParameters,
    String? orderParameters,
    List<String>? fields,
  }) async {
    final Database db = database != null ? database : await this.database;
    return (await db.query(entity.tableName,
        where: whereParameters, orderBy: orderParameters, columns: fields));
  }

  Future<List<T>> findWhere(
      {Database? database,
      String? whereParameters,
      String? orderParameters,
      List<String>? fields,
      List<ColumnRelation>? relations}) async {
    final Database db = database != null ? database : await this.database;

    final dataResults = (await db.query(this.entity.tableName,
        where: whereParameters, orderBy: orderParameters, columns: fields));

    final List<String> dataIds =
        dataResults.map((dataResult) => dataResult['id'].toString()).toList();

    final relationData = relations != null
        ? await this.findRelationByParent(
            relations: relations,
            dataIds: dataIds,
            orderParameters: orderParameters,
            database: db)
        : [];

    return dataResults.map((e) {
      Map<String, dynamic> resultMap = {...e};

      (relationData ?? []).forEach((relationDataItem) {
        final availableRelationData = (relationDataItem['data'] ?? [])
            .where((relationItem) =>
                relationItem[relationDataItem['referencedColumn']] ==
                resultMap['id'])
            .toList();

        resultMap[relationDataItem['relation']] = availableRelationData;
      });
      return getObject<T>(resultMap);
    }).toList();
  }

  @override
  Future<T?> findById(
      {required String id,
      List<String>? fields,
      Database? database,
      List<ColumnRelation>? relations}) async {
    final Database db = database != null ? database : await this.database;

    var results = await this.find(id: id, fields: fields, database: db);

    return results.length > 0 ? results[0] : null;
  }

  @override
  Future<int> insertMany(
      {required List<T> entities, Database? database}) async {
    final Database db = database != null ? database : await this.database;

    await Future.forEach(
        entities, ((T entity) => insertOne(entity: entity, database: db)));

    return 1;
  }

  @override
  Future<int> insertOne({required T entity, Database? database}) async {
    Map<String, dynamic> data = this
        .sanitizeIncomingData(entity: entity.toJson(), columns: this.columns);
    final Database db = database != null ? database : await this.database;

    final saveDataResponse = await db.insert(this.entity.tableName, data);

    if (this.oneToManyColumns.isEmpty) {
      return saveDataResponse;
    }

    final queue = Queue(parallel: 50);
    num availableItemCount = 0;

    this.oneToManyColumns.forEach((Column column) {
      final List data = entity.toJson()[column.relation?.attributeName] ?? [];
      if (data.isNotEmpty) {
        availableItemCount++;
        data.forEach((dataItem) {
          queue.add(() => saveRelationData(
              columnRelation: column.relation as ColumnRelation,
              entity: dataItem,
              database: db));
        });
      }
    });

    if (availableItemCount == 0) {
      queue.cancel();
      return saveDataResponse;
    }

    await queue.onComplete;
    return saveDataResponse;
  }

  Future saveRelationData(
      {required ColumnRelation columnRelation,
      required BaseEntity entity,
      Database? database}) async {
    Map<String, dynamic> data = this.sanitizeIncomingData(
        entity: entity.toJson(),
        columns: columnRelation.referencedEntityColumns as List<Column>);

    final Database db = database != null ? database : await this.database;

    var result = await db.query(
        columnRelation.referencedEntity?.tableName as String,
        where: 'id = ?',
        whereArgs: [data['id']]);

    dynamic saveDataResponse;
    if (result.length == 0) {
      saveDataResponse = await db.insert(
          columnRelation.referencedEntity?.tableName as String, data);
    } else {
      final lastUpdated = result[0]['lastModifiedDate'];
      if (lastUpdated != null) {
        final currentLastUpdatedDate = DateTime.parse(lastUpdated as String);

        final newLastUpdatedDate =
            DateTime.parse(data['lastModifiedDate'] as String);

        if (currentLastUpdatedDate
                .difference(newLastUpdatedDate)
                .inMilliseconds >
            0) {
          saveDataResponse = 1;
        } else {
          if (data['dirty'] == 1) {
            data['lastModifiedDate'] = DateHelper.nowUtc();
          }
          saveDataResponse = await db.update(
            columnRelation.referencedEntity?.tableName as String,
            data,
            where: "id = ?",
            whereArgs: [data['id']],
          );
        }
      } else {
        saveDataResponse = 1;
      }
    }

    final List<Column?>? oneToManyColumns = columnRelation
        .referencedEntityColumns
        ?.where((column) =>
            column?.relation?.relationType == RelationType.OneToMany)
        .toList();

    if (oneToManyColumns!.isEmpty) {
      return saveDataResponse;
    }

    final queue = Queue(parallel: 50);
    num availableItemCount = 0;

    oneToManyColumns.forEach((Column? column) {
      final List data = entity.toJson()[column?.relation?.attributeName];

      if (data.isNotEmpty) {
        availableItemCount++;
        data.forEach((dataItem) {
          queue.add(() => saveRelationData(
              columnRelation: column?.relation as ColumnRelation,
              entity: dataItem,
              database: db));
        });
      }
    });

    if (availableItemCount == 0) {
      queue.cancel();
      return saveDataResponse;
    }

    await queue.onComplete;

    return saveDataResponse;
  }

  @override
  Future<int> deleteByIds(
      {required List<String> ids, Database? database}) async {
    final Database db = database != null ? database : await this.database;

    await db.delete(this.entity.tableName,
        where: 'id IN (?)', whereArgs: [ids.join(',')]);

    return 1;
  }

  @override
  Future<int> deleteById({required String id, Database? database}) async {
    final Database db = database != null ? database : await this.database;

    await db.delete(this.entity.tableName, where: 'id = ?', whereArgs: [id]);

    return 1;
  }

  @override
  Future<int> deleteAll({Database? database}) async {
    final Database db = database != null ? database : await this.database;

    await db.delete(this.entity.tableName);

    return 1;
  }

  @override
  Future<int> saveMany(
      {required List<T> entities,
      Database? database,
      int? chunk,
      required MergeMode mergeMode,
      SaveOptions? saveOptions}) async {
    final Database db = database != null ? database : await this.database;

    if (entities.isEmpty) {
      return 1;
    }

    final queue = Queue(parallel: chunk ?? 500);

    entities.forEach((T entity) {
      queue.add(() => saveOne(
          entity: entity,
          database: db,
          mergeMode: mergeMode,
          saveOptions: saveOptions));
    });

    await queue.onComplete;

    return 1;
  }

  @override
  Future<int> saveOne(
      {required T entity,
      Database? database,
      required MergeMode mergeMode,
      SaveOptions? saveOptions}) async {
    final Database db = database != null ? database : await this.database;

    var result = await this.findById(id: entity.id as String, database: db);

    if (result != null) {
      final currentLastUpdatedDate =
          DateTime.parse(result.lastModifiedDate as String);
      final newLastUpdatedDate =
          DateTime.parse(entity.lastModifiedDate as String);

      if (currentLastUpdatedDate.difference(newLastUpdatedDate).inMilliseconds >
          0) {
        return 0;
      }

      T newEntity = entity;

      if (mergeMode == MergeMode.Merge) {
        Map<String, dynamic> localData = result.toJson();
        Map<String, dynamic> entityMap = entity.toJson();

        if (saveOptions?.skipLocalSyncStatus == null ||
            saveOptions?.skipLocalSyncStatus == false) {
          entityMap['synced'] = localData['synced'];
        }

        localData.keys.forEach((key) {
          if (entityMap[key] == null) {
            entityMap[key] = localData[key];
          }
        });

        this.columns.forEach((column) {
          if (column.relation == null) {
            if (entityMap[column.name] == null) {
              entityMap[column.name as String] = localData[column.name];
            }
          }
        });

        ClassMirror classMirror =
            AnnotationReflectable.reflectType(T) as ClassMirror;

        newEntity = classMirror.newInstance('fromJson', [entityMap]) as T;
      }

      return this.updateOne(entity: newEntity, database: db);
    }

    return this.insertOne(entity: entity, database: db);
  }

  @override
  Future<int> updateMany(
      {required List<T> entities, Database? database, int? chunk}) async {
    final Database db = database != null ? database : await this.database;

    final queue = Queue(parallel: chunk ?? 500);

    entities.forEach((T entity) {
      queue.add(() => updateOne(entity: entity, database: db));
    });

    await queue.onComplete;

    return 1;
  }

  @override
  Future<int> updateOne({required T entity, Database? database}) async {
    T newEntity = entity;
    if (newEntity.dirty == true) {
      ClassMirror classMirror =
          AnnotationReflectable.reflectType(T) as ClassMirror;

      newEntity = classMirror.newInstance('fromJson', [
        {...newEntity.toJson(), 'lastModifiedDate': DateHelper.nowUtc()}
      ]) as T;
      // entity.lastModifiedDate = DateHelper.nowUtc();
    }
    Map<String, dynamic> data = this.sanitizeIncomingData(
        entity: newEntity.toJson(), columns: this.columns);
    final Database db = database != null ? database : await this.database;
    final saveDataResponse = await db.update(
      this.entity.tableName,
      data,
      where: "id = ?",
      whereArgs: [data['id']],
    );

    if (this.oneToManyColumns.isEmpty) {
      return saveDataResponse;
    }

    final queue = Queue(parallel: 50);
    num availableItemCount = 0;

    this.oneToManyColumns.forEach((Column column) {
      final List data =
          newEntity.toJson()[column.relation?.attributeName] ?? [];
      if (data.isNotEmpty) {
        availableItemCount++;
        data.forEach((dataItem) {
          queue.add(() => saveRelationData(
              columnRelation: column.relation as ColumnRelation,
              entity: dataItem,
              database: db));
        });
      }
    });

    if (availableItemCount == 0) {
      queue.cancel();
      return saveDataResponse;
    }

    await queue.onComplete;
    return saveDataResponse;
  }

  // @override
  List<Column> get columns => Entity.getEntityColumns(
      AnnotationReflectable.reflectType(T) as ClassMirror, false);

  // @override
  List<Column> get oneToManyColumns => this
      .columns
      .where(
          (column) => column.relation?.relationType == RelationType.OneToMany)
      .toList();

  // @override
  String get createQuery => QueryExpression.getCreateTableExpression(
      this.entity.tableName, this.columns);

  @override
  Future create({Database? database}) async {
    final Database db = database != null ? database : await this.database;

    await db.transaction((txn) async {
      var batch = txn.batch();

      this.createQuery.split(';').forEach((sql) {
        batch.execute(sql);
      });

      await batch.commit();
    });

    return 1;
  }

  // @override
  Entity get entity {
    return Entity.getEntityDefinition(
        AnnotationReflectable.reflectType(T) as ClassMirror);
  }

  @override
  Map<String, dynamic> sanitizeIncomingData(
      {required Map<String, dynamic> entity, required List<Column> columns}) {
    Map<String, dynamic> data = new Map();
    columns.forEach((column) {
      if (column.type == ColumnType.BOOLEAN) {
        data[column.name as String] =
            entity[column.attributeName] == true ? 1 : 0;
      } else if (column.relation != null) {
        if (column.relation?.relationType != RelationType.OneToMany) {
          final entityByAttribute = entity[column.attributeName];

          if (entityByAttribute != null) {
            data[column.name as String] =
                entityByAttribute.runtimeType == String
                    ? entityByAttribute
                    : entityByAttribute[column.relation?.referencedColumn];
          }
        }
      } else {
        if (entity[column.attributeName] is List) {
          data[column.name as String] = entity[column.attributeName].toString();
        } else {
          data[column.name as String] = entity[column.attributeName];
        }
      }
    });

    return data;
  }

  T getObject<T>(Map<String, dynamic> objectMap) {
    ClassMirror classMirror =
        AnnotationReflectable.reflectType(T) as ClassMirror;

    return RepositoryUtil.getEntityData(
        columns: this.columns,
        objectMap: objectMap,
        classMirror: classMirror) as T;
  }

  @override
  Future<int> count({Database? database}) async {
    final Database db = database != null ? database : await this.database;

    final countResult = await db
        .rawQuery('SELECT COUNT(*) as count FROM ${this.entity.tableName}');

    return countResult[0]['count'] as int;
  }

  Future<List<Map>> rawQuery(
      {required String query, Database? database}) async {
    final Database db = database != null ? database : await this.database;

    final List<Map> queryResult = await db.rawQuery(query.toString());

    return queryResult;
  }
}

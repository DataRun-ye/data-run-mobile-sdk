/// BaseQuery is a class that provides a way to query the database and the DHIS2 server.
/// It is used to perform CRUD operations on entities.
///
import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/core/datarun/utilities/date_helper.dart';
import 'package:d2_remote/core/utilities/sqflite_data_store.dart';
import 'package:d2_remote/shared/queries/base.repository.dart';
import 'package:d2_remote/shared/utilities/data-run-url-generator.util.dart';
import 'package:d2_remote/shared/entities/base.entity.dart';
import 'package:d2_remote/shared/models/request_progress.model.dart';
import 'package:d2_remote/shared/utilities/dhis-url-generator.util.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:d2_remote/shared/utilities/merge_mode.util.dart';
import 'package:d2_remote/shared/utilities/query_filter.util.dart';
import 'package:d2_remote/shared/utilities/query_filter_condition.util.dart';
import 'package:d2_remote/shared/utilities/query_model.util.dart';
import 'package:d2_remote/shared/utilities/save_option.util.dart';
import 'package:d2_remote/shared/utilities/sort_order.util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:reflectable/mirrors.dart';

@AnnotationReflectable
class BaseQuery<T extends BaseEntity> implements BaseRepository<T> {
  late DataStore<T> dataSource;
  dynamic data;
  List<String>? fields;
  Column? primaryKey;
  String? tableName;
  String? apiResourceName;
  String? singularResourceName;
  String? id;
  List<QueryFilter>? filters = [];
  Map<String, SortOrder> sortOrder = {};
  List<ColumnRelation> relations = [];
  MergeMode _mergeMode = MergeMode.Replace;

  // NMC
  LogicalOperator operator = LogicalOperator.AND;

  BaseQuery(this.dataSource) {
    this.tableName = dataSource.entity.tableName;
    this.apiResourceName = dataSource.entity.apiResourceName;

    Iterable<Column> newColumns = dataSource.columns.where((column) =>
        column.relation == null ||
        column.relation?.relationType != RelationType.OneToMany);

    this.fields = newColumns.map((column) => column.name ?? '').toList();
    this.primaryKey = dataSource.columns.firstWhere((column) => column.primary);
  }

  set mergeMode(MergeMode mergeMode) {
    this._mergeMode = mergeMode;
  }

  BaseQuery<T> setOperator(LogicalOperator operator) {
    operator = operator;
    return this;
  }

  BaseQuery<T> resetFilters() {
    id = null;
    filters?.clear();
    operator = LogicalOperator.AND;
    return this;
  }

  BaseQuery<T> select(List<String> fields) {
    this.fields = fields;
    return this;
  }

  BaseQuery<T> byId(String id) {
    this.id = id;
    this.filters = null;
    return this;
  }

  BaseQuery<T> byIds(List<String> ids) {
    this.id = null;
    return this.whereIn(attribute: 'id', values: ids, merge: false);
  }

  BaseQuery<T> whereIn(
      {required String attribute,
      required List<String> values,
      bool merge = false}) {
    if (merge) {
      this.filters?.add(QueryFilter(
          attribute: attribute, condition: QueryCondition.In, value: values));
    } else {
      this.filters = [
        QueryFilter(
            attribute: attribute, condition: QueryCondition.In, value: values)
      ];
    }

    return this;
  }

  BaseQuery<T> where({required String attribute, @required dynamic value}) {
    this.filters?.add(QueryFilter(
        attribute: attribute, condition: QueryCondition.Equal, value: value));

    return this;
  }

  // NMC
  BaseQuery<T> whereNotIn(
      {required String attribute,
      required List<String> values,
      required bool merge}) {
    if (merge) {
      this.filters?.add(QueryFilter(
          attribute: attribute, condition: QueryCondition.Nin, value: values));
    } else {
      this.filters = [
        QueryFilter(
            attribute: attribute, condition: QueryCondition.Nin, value: values)
      ];
    }

    return this;
  }

  BaseQuery<T> whereNeq({required String attribute, @required dynamic value}) {
    this.filters?.add(QueryFilter(
        attribute: attribute, condition: QueryCondition.Neq, value: value));

    return this;
  }

  //

  BaseQuery<T> like({required String attribute, required dynamic value}) {
    this.filters?.add(QueryFilter(
        attribute: attribute, condition: QueryCondition.Like, value: value));
    return this;
  }

  BaseQuery<T> ilike(
      {required String attribute,
      required dynamic value,
      String? filterCondition,
      String? key,
      String? keyValue}) {
    this.filters?.add(QueryFilter(
        attribute: attribute,
        condition: QueryCondition.Ilike,
        value: value,
        filterCondition: filterCondition,
        key: key,
        keyValue: keyValue));
    return this;
  }

  BaseQuery<T> greaterThan(
      {required String attribute, required dynamic value}) {
    this.filters?.add(QueryFilter(
        attribute: attribute,
        condition: QueryCondition.GreaterThan,
        value: value));
    return this;
  }

  BaseQuery<T> greaterThanOrEqual(
      {required String attribute, required dynamic value}) {
    this.filters?.add(QueryFilter(
        attribute: attribute,
        condition: QueryCondition.GreaterThanOrEqualTo,
        value: value));
    return this;
  }

  BaseQuery<T> lessThan({required String attribute, @required dynamic value}) {
    this.filters?.add(QueryFilter(
        attribute: attribute,
        condition: QueryCondition.LessThan,
        value: value));
    return this;
  }

  BaseQuery<T> lessThanOrEqual(
      {required String attribute, required dynamic value}) {
    this.filters?.add(QueryFilter(
        attribute: attribute,
        condition: QueryCondition.LessThanOrEqualTo,
        value: value));
    return this;
  }

  BaseQuery<T> orderBy({required String attribute, required SortOrder order}) {
    this.sortOrder[attribute] = order;
    return this;
  }

  BaseQuery<T> setData(dynamic data) {
    this.data = data;
    return this;
  }

  QueryModel get query {
    List<QueryFilter>? filters = this.filters;
    if (this.id != null) {
      filters = [
        QueryFilter(
            attribute: 'id', condition: QueryCondition.Equal, value: this.id)
      ];
    }

    return QueryModel(
        resourceName: this.apiResourceName as String,
        tableName: this.tableName as String,
        singularResourceName: this.singularResourceName,
        fields: this.fields as List<String>,
        filters: filters,
        relations: this.relations,
        columns: this.dataSource.columns);
  }

  Future<List<T>> get(
      {Dio? dioTestClient, bool? online, int? limit, int? offset}) async {
    if (online == true) {
      return this.fetchOnline(dioTestClient: dioTestClient);
    }

    if (this.id != null) {
      return this.dataSource.find(
          id: this.id,
          fields: this.fields as List<String>,
          // database: this.database,
          relations: this.relations);
    }

    return this.dataSource.findAll(
        // database: this.database,
        filters: this.filters,
        fields: this.fields as List<String>,
        sortOrder: this.sortOrder,
        relations: this.relations,
        operator: operator,
        offset: offset,
        limit: limit);
  }

  Future<T?> getOne({Dio? dioTestClient, bool? online}) async {
    if (online == true) {
      return (await this.fetchOnline(dioTestClient: dioTestClient))[0];
    }

    List<T> results = await this.get();

    return results.length > 0 ? results[0] : null;
  }

  Future<int> save({SaveOptions? saveOptions}) async {
    if (this.data is List) {
      return this.dataSource.saveMany(
          entities: this.data as List<T>,
          // database: this.database,
          mergeMode: this._mergeMode,
          saveOptions: saveOptions);
    }
    if (this.data != null && this.data!.lastModifiedDate == null) {
      ClassMirror classMirror =
          AnnotationReflectable.reflectType(T) as ClassMirror;

      this.data = classMirror.newInstance('fromJson', [
        {...this.data!.toJson(), 'lastModifiedDate': DateHelper.nowUtc()}
      ]);
    }

    return this.dataSource.saveOne(
        entity: this.data as T,
        // database: this.database,
        mergeMode: this._mergeMode,
        saveOptions: saveOptions);
  }

  Future<int> delete() {
    if (this.id != null) {
      return this.dataSource.deleteById(
            id: this.id as String,
            // database: this.database,
          );
    }

    return this.dataSource.deleteAll();
  }

  Future createTable() async {
    return await this.dataSource.create(
        // database: this.database,
        );
  }

  Future<int> count() {
    return this.dataSource.count(
        // database: this.database,
        );
  }

  Future create() {
    return this.dataSource.create(
        // database: database,
        );
  }

  Future<List<T>> fetchOnline({Dio? dioTestClient}) async {
    // final dhisUrl = await this.dhisUrl();
    final dataRunUrl = await this.dataRunUrl();
    final response = await HttpClient.get(
      dataRunUrl,
      // database: this.database,
      dioTestClient: dioTestClient,
    );

    List data = response.body != null
        ? response.body[this.apiResourceName]?.toList() ?? []
        : [];

    return data.map((dataItem) {
      dataItem['dirty'] = false;
      dataItem['synced'] = true;
      // //DRun
      // dataItem['status'] = 'COMPLETED';
      ClassMirror classMirror =
          AnnotationReflectable.reflectType(T) as ClassMirror;

      var x = classMirror.newInstance('fromJson', [dataItem]) as T;

      return x;
    }).toList();
  }

  Future<List<T>?> download(Function(RequestProgress, bool) callback,
      {Dio? dioTestClient}) async {
    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                'Downloading ${this.apiResourceName?.toLowerCase()} from the server....',
            status: '',
            percentage: 0),
        false);

    this.data = await this.fetchOnline(dioTestClient: dioTestClient);

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                '${data.length} ${this.apiResourceName?.toLowerCase()} downloaded successfully',
            status: '',
            percentage: 50),
        false);

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                'Saving ${data.length} ${this.apiResourceName?.toLowerCase()} into phone database...',
            status: '',
            percentage: 51),
        false);

    await this.save();

    callback(
        RequestProgress(
            resourceName: this.apiResourceName as String,
            message:
                '${data.length} ${this.apiResourceName?.toLowerCase()} successfully saved into the database',
            status: '',
            percentage: 100),
        true);

    return this.data;
  }

  Future<String> dhisUrl() {
    return Future.value(DhisUrlGenerator.generate(this.query));
  }

  // Data Run
  Future<String> dataRunUrl() {
    return Future.value(DataRunUrlGenerator.generate(this.query));
  }
}

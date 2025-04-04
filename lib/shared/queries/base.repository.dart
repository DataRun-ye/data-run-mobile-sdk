import 'package:d2_remote/shared/mixin/d_run_base.dart';
import 'package:d2_remote/shared/utilities/query_filter.util.dart';
import 'package:d2_remote/shared/utilities/query_filter_condition.util.dart';
import 'package:d2_remote/shared/utilities/save_option.util.dart';
import 'package:d2_remote/shared/utilities/sort_order.util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class BaseRepository<T extends DRunBase> {
  // Database? database;
  // BaseDataStore<T> get dataStore;
  String? id;
  List<QueryFilter>? filters = [];
  LogicalOperator operator = LogicalOperator.AND;

  List<String>? get fields;

  String? get tableName;

  String? get apiResourceName;

  BaseRepository<T> resetFilters();

  BaseRepository<T> select(List<String> fields);

  BaseRepository<T> byId(String id);

  BaseRepository<T> byIds(List<String> ids);

  BaseRepository<T> whereIn(
      {required String attribute, required List<String> values});

  BaseRepository<T> where({required String attribute, required dynamic value});

  // NMC
  BaseRepository<T> whereNotIn(
      {required String attribute,
      required List<String> values,
      required bool merge});

  BaseRepository<T> whereNeq(
      {required String attribute, @required dynamic value});

  BaseRepository<T> like({required String attribute, required dynamic value});

  BaseRepository<T> orderBy(
      {required String attribute, required SortOrder order});

  BaseRepository<T> setData(T? data);

  Future<List<T>> get(
      {Dio? dioTestClient, bool? online, int? limit, int? offset});

  Future<T?> getOne({Dio? dioTestClient, bool? online});

  Future<int> save({SaveOptions? saveOptions});

  Future<int> delete();

  Future<int> count();

  /// create
  Future createTable();

  Future create();
}

import 'dart:async';

import 'package:d2_remote/core/database/run_module.dart';
import 'package:d2_remote/modules/metadatarun/data_element/entities/data_element.entity.dart';
import 'package:d2_remote/modules/metadatarun/data_element/queries/data_element.query.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DataElementModule extends RunModule<DataElement> {
  final DataElementQuery dataElement;

  DataElementModule(this.dataElement);

  @PostConstruct(preResolve: true)
  @override
  Future<void> initialize() async {
    await dataElement.createTable();
  }

  // @disposeMethod
  // @override
  // FutureOr<void> dispose() async {
  //   return super.dispose();
  // }
}

import 'dart:async';

import 'package:d2_remote/shared/entities/base.entity.dart';

abstract class RunModule<T extends BaseEntity> {
  Future<void> initialize();

// FutureOr<void> dispose();
}

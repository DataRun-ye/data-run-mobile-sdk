import 'package:d2_remote/core/annotations/index.dart' as legacy;
import 'package:d2_remote/core/datarun/utilities/date_helper.dart';
import 'package:d2_remote/shared/mixin/d_run_base.dart';
import 'package:d2_remote/shared/utilities/dhis_uid_generator.util.dart';

// @legacy.AnnotationReflectable
class BaseEntity implements DRunBase {
  @legacy.PrimaryColumn()
  late final String? id;

  // @legacy.Column(nullable: true)
  // late final String? uid;

  @legacy.Column()
  final bool dirty;

  @legacy.Column(nullable: true)
  final String? lastModifiedDate;

  @legacy.Column(nullable: true)
  final String? createdDate;

  BaseEntity(
      {String? id,
      // String? uid,
      required this.dirty,
      String? createdDate,
      String? lastModifiedDate})
      : this.id = id ?? DhisUidGenerator.generate(),
        this.createdDate = createdDate ?? DateHelper.nowUtc(),
        this.lastModifiedDate =
            lastModifiedDate ?? createdDate ?? DateHelper.nowUtc();

  static fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

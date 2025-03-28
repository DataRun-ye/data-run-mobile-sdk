import 'package:d2_remote/shared/mixin/d_run_base.dart';

abstract class DRunIdentifiableBase extends DRunBase {
  String? get id;

  String? get code;

  String? get name;

  String? get displayName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DRunIdentifiableBase &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code &&
          name == other.name &&
          displayName == other.displayName);

  @override
  int get hashCode =>
      id.hashCode ^ code.hashCode ^ name.hashCode ^ displayName.hashCode;

  @override
  String toString() {
    return 'IdentifiableModel{' +
        ' id: $id,' +
        ' code: $code,' +
        ' name: $name,' +
        ' displayName: $displayName,' +
        '}';
  }
}

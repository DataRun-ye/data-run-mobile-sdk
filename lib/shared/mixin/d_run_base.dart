abstract class DRunBase {
  String? get id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DRunBase &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'IdentifiableModel{' + ' id: $id,' + '}';
  }
}

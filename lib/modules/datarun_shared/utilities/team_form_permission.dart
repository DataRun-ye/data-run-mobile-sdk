import 'package:d2_remote/modules/datarun_shared/utilities/form_permission.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class TeamFormPermission with EquatableMixin {
  final String form;
  final bool downloaded;
  final IList<FormPermission> permissions;

  TeamFormPermission(
      {required this.form,
      Iterable<FormPermission>? permissions,
      this.downloaded = false})
      : this.permissions = IList.orNull(permissions) ?? IList([]);

  bool hasPermission(FormPermission action) {
    return permissions.any((permission) => permission == action);
  }

  factory TeamFormPermission.fromJson(Map<String, dynamic> json) {
    final permissions = json['permissions'] != null
        ? (parseDynamicJson(json['permissions']) as List)
            .map((permission) => FormPermission.getType(permission)!)
            .toList()
        : <FormPermission>[];

    return TeamFormPermission(
      form: json['form'],
      permissions: permissions,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'form': form,
      'downloaded': downloaded,
      'permissions': permissions.map((permission) => permission.name).toList(),
    };
  }

  @override
  List<Object?> get props => [form, permissions, downloaded];

  TeamFormPermission copyWith({
    String? form,
    bool? downloaded,
    Iterable<FormPermission>? permissions,
  }) {
    return TeamFormPermission(
      form: form ?? this.form,
      downloaded: downloaded ?? this.downloaded,
      permissions: permissions ?? this.permissions,
    );
  }
}

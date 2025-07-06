import 'package:d2_remote/modules/datarun_shared/utilities/form_permission.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/parsing_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class TeamFormPermission with EquatableMixin {
  final String team;
  final String form;
  final IList<FormPermission> permissions;

  TeamFormPermission(
      {required this.team,
      required this.form,
      Iterable<FormPermission>? permissions})
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
      team: json['team'],
      form: json['form'],
      permissions: permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team': team,
      'form': form,
      'permissions': permissions.map((permission) => permission.name).toList(),
    };
  }

  @override
  List<Object?> get props => [team, form, permissions];
}

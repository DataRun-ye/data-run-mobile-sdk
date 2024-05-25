import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/data_run/auth/user/entities/d_user.entity.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@AnnotationReflectable
@Entity(
    tableName: 'dUserOrganisationUnit', apiResourceName: 'userVillageLocations')
class DUserOrganisationUnit extends IdentifiableEntity {
  @Column()
  final String orgUnit;

  @Column()
  final String type;

  @ManyToOne(joinColumnName: 'user', table: DUser)
  dynamic user;

  DUserOrganisationUnit(
      {required String id,
      required String name,
      required this.orgUnit,
      required this.user,
      required this.type,
      required bool dirty})
      : super(id: id, name: name, dirty: dirty);

  factory DUserOrganisationUnit.fromJson(Map<String, dynamic> json) {
    return DUserOrganisationUnit(
        id: json['id'],
        name: json['id'],
        orgUnit: json['orgUnit'],
        user: json['user'],
        type: json['type'],
        dirty: json['dirty']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['orgUnit'] = this.orgUnit;
    data['type'] = this.type;
    data['user'] = this.user;
    data['dirty'] = this.dirty;
    return data;
  }
}

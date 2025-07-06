import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/core/utilities/repository.dart';
import 'package:d2_remote/modules/datarun/form/entities/form_template.entity.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/active_status.dart';
import 'package:d2_remote/modules/metadatarun/activity/entities/d_activity.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class ActivityQuery extends BaseQuery<Activity> {
  ActivityQuery({Database? database}) : super(database: database);
  String? project;
  ActiveStatus? activeStatus;

  ActivityQuery withFormTemplates() {
    final formTemplate = Repository<FormTemplate>();
    final Column? relationColumn = formTemplate.columns.firstWhere((column) =>
        column.relation?.referencedEntity?.tableName == this.tableName);

    if (relationColumn != null) {
      ColumnRelation relation = ColumnRelation(
          referencedColumn: relationColumn.relation?.attributeName,
          attributeName: 'formTemplates',
          primaryKey: this.primaryKey?.name,
          relationType: RelationType.OneToMany,
          referencedEntity: Entity.getEntityDefinition(
              AnnotationReflectable.reflectType(FormTemplate) as ClassMirror),
          referencedEntityColumns: Entity.getEntityColumns(
              AnnotationReflectable.reflectType(FormTemplate) as ClassMirror,
              false));
      this.relations.add(relation);
    }

    return this;
  }

  ActivityQuery byProject(String project) {
    this.project = project;
    this.where(attribute: 'project', value: project);
    return this;
  }

  ActivityQuery byActivityStatus(ActiveStatus activeStatus) {
    this.activeStatus = activeStatus;
    switch (activeStatus) {
      case ActiveStatus.EnabledOnly:
        this.where(attribute: 'disabled', value: false);
        return this;
      case ActiveStatus.DisabledOnly:
        this.where(attribute: 'disabled', value: true);
        return this;
      default:
        return this;
    }
  }
}

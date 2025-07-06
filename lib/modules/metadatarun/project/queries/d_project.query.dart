import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/metadatarun/project/entities/d_project.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class ProjectQuery extends BaseQuery<Project> {
  ProjectQuery({Database? database}) : super(database: database);
}

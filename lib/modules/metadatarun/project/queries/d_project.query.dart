import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/metadatarun/project/entities/d_project.entity.dart';
import 'package:d2_remote/modules/metadatarun/project/repository/project_repository.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:injectable/injectable.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
@lazySingleton
class ProjectQuery extends BaseQuery<Project> {
  final ProjectRepository dataSource;
  ProjectQuery(this.dataSource) : super(dataSource);
}

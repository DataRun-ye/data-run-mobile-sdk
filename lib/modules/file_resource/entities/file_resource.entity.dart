// import 'dart:convert';
//
// import 'package:d2_remote/core/annotations/index.dart';
// import 'package:d2_remote/shared/entities/identifiable.entity.dart';
//
// @AnnotationReflectable
// @Entity(tableName: 'fileResource', apiResourceName: 'fileResources')
// class FileResource extends IdentifiableEntity {
//   @Column(nullable: true)
//   String? resourceId;
//
//   @Column()
//   String elementId;
//
//   @Column()
//   String elementType;
//
//   @Column()
//   String formInstance;
//
//   @Column()
//   String contentType;
//
//   @Column(nullable: true)
//   String? contentLength;
//
//   @Column()
//   String storageStatus;
//   @Column()
//   String localFilePath;
//
//   @Column(nullable: true)
//   bool? synced;
//
//   @Column(nullable: true)
//   bool? syncFailed;
//
//   @Column(nullable: true)
//   String? lastSyncSummary;
//
//   @Column(nullable: true)
//   String? lastSyncDate;
//
//   FileResource(
//       {String? id,
//       required this.elementId,
//       required this.formInstance,
//       required this.elementType,
//       this.resourceId,
//       String? name,
//       required this.contentType,
//       this.contentLength,
//       required this.storageStatus,
//       required this.localFilePath,
//       this.synced,
//       this.syncFailed,
//       this.lastSyncSummary,
//       this.lastSyncDate,
//       String? createdDate,
//       String? lastModifiedDate,
//       required bool dirty})
//       : super(
//             uid: id,
//             name: name,
//             dirty: dirty,
//             createdDate: createdDate,
//             lastModifiedDate: lastModifiedDate) {
//     this.uid = this.uid ?? '${this.formInstance}_${this.elementId}';
//     this.name = this.name ?? this.localFilePath;
//   }
//
//   factory FileResource.fromJson(Map<String, dynamic> json) {
//     const JsonEncoder encoder = JsonEncoder();
//     final dynamic lastSyncSummary = encoder.convert(json['lastSyncSummary']);
//     return FileResource(
//         id: json['id'],
//         elementId: json['elementId'],
//         elementType: json['elementType'],
//         formInstance: json['formInstance'],
//         resourceId: json['resourceId'],
//         name: json['name'],
//         contentType: json['contentType'],
//         contentLength: json['contentLength'],
//         storageStatus: json['storageStatus'],
//         localFilePath: json['localFilePath'],
//         synced: json['synced'],
//         syncFailed: json['syncFailed'],
//         lastSyncSummary: lastSyncSummary,
//         lastSyncDate: json['lastSyncDate'],
//         createdDate: json['createdDate'],
//         lastModifiedDate: json['lastModifiedDate'],
//         dirty: json['dirty'] ?? false);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['uid'] = this.id;
//     data['elementId'] = this.elementId;
//     data['elementType'] = this.elementType;
//     data['formInstance'] = this.formInstance;
//     data['resourceId'] = this.resourceId;
//     data['name'] = this.name;
//     data['contentType'] = this.contentType;
//     data['contentLength'] = this.contentLength;
//     data['storageStatus'] = this.storageStatus;
//     data['localFilePath'] = this.localFilePath;
//     data['synced'] = this.synced;
//     data['syncFailed'] = this.syncFailed;
//     data['lastSyncSummary'] = this.lastSyncSummary;
//     data['lastSyncDate'] = this.lastSyncDate;
//     data['createdDate'] = this.createdDate;
//     data['lastModifiedDate'] = this.lastModifiedDate;
//     data['dirty'] = this.dirty;
//     return data;
//   }
// }

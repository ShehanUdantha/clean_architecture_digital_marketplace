import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/notification/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dateCreated,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dateCreated': dateCreated,
      };

  factory NotificationModel.fromEntity(NotificationEntity notificationEntity) =>
      NotificationModel(
        id: notificationEntity.id,
        title: notificationEntity.title,
        description: notificationEntity.description,
        dateCreated: notificationEntity.dateCreated,
      );

  factory NotificationModel.fromMap(
    QueryDocumentSnapshot<Map<String, dynamic>> map,
  ) =>
      NotificationModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        dateCreated: map['dateCreated'],
      );

  factory NotificationModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) =>
      NotificationModel(
        id: document['id'],
        title: document['title'],
        description: document['description'],
        dateCreated: document['dateCreated'],
      );
}

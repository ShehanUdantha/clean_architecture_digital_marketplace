import 'package:Pixelcart/src/data/models/notification/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/notification_values.dart';
import 'notification_model_test.mocks.dart';

@GenerateMocks([QueryDocumentSnapshot, DocumentSnapshot])
void main() {
  late MockQueryDocumentSnapshot<Map<String, dynamic>>
      mockQueryDocumentSnapshot;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

  setUp(() {
    mockQueryDocumentSnapshot =
        MockQueryDocumentSnapshot<Map<String, dynamic>>();
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
  });

  test(
    'should correctly convert NotificationModel to JSON',
    () {
      // Act
      final json = notificationModel.toJson();

      // Assert
      expect(json, notificationJson);
    },
  );

  test(
    'should correctly create NotificationModel from Entity',
    () {
      // Act
      final notificationFromEntity =
          NotificationModel.fromEntity(notificationEntity);

      // Assert
      expect(notificationFromEntity, equals(notificationModel));
    },
  );

  test(
    'should correctly create NotificationModel from Firestore Query Snapshot',
    () {
      // Arrange
      when(mockQueryDocumentSnapshot.data()).thenReturn(notificationJson);
      when(mockQueryDocumentSnapshot['id']).thenReturn(notificationJson['id']);
      when(mockQueryDocumentSnapshot['title'])
          .thenReturn(notificationJson['title']);
      when(mockQueryDocumentSnapshot['description'])
          .thenReturn(notificationJson['description']);
      when(mockQueryDocumentSnapshot['dateCreated'])
          .thenReturn(notificationJson['dateCreated']);

      // Act
      final model = NotificationModel.fromMap(mockQueryDocumentSnapshot);

      // Assert
      expect(model, equals(notificationModel));
    },
  );

  test(
    'should correctly create NotificationModel from Firestore Document',
    () {
      // Arrange
      when(mockDocumentSnapshot.data()).thenReturn(notificationJson);
      when(mockDocumentSnapshot['id']).thenReturn(notificationJson['id']);
      when(mockDocumentSnapshot['title']).thenReturn(notificationJson['title']);
      when(mockDocumentSnapshot['description'])
          .thenReturn(notificationJson['description']);
      when(mockDocumentSnapshot['dateCreated'])
          .thenReturn(notificationJson['dateCreated']);

      // Act
      final model = NotificationModel.fromDocument(mockDocumentSnapshot);

      // Assert
      expect(model, equals(notificationModel));
    },
  );
}

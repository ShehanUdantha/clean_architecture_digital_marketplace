import 'package:Pixelcart/src/data/models/notification/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
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
      final json = dummyNotification.toJson();

      // Assert
      expect(json, dummyNotificationJson);
    },
  );

  test(
    'should correctly create NotificationModel from Entity',
    () {
      // Act
      final notificationFromEntity =
          NotificationModel.fromEntity(dummyNotificationEntityTwo);

      // Assert
      expect(notificationFromEntity, equals(dummyNotification));
    },
  );

  test(
    'should correctly create NotificationModel from Firestore Query Snapshot',
    () {
      // Arrange
      when(mockQueryDocumentSnapshot.data()).thenReturn(dummyNotificationJson);
      when(mockQueryDocumentSnapshot['id'])
          .thenReturn(dummyNotificationJson['id']);
      when(mockQueryDocumentSnapshot['title'])
          .thenReturn(dummyNotificationJson['title']);
      when(mockQueryDocumentSnapshot['description'])
          .thenReturn(dummyNotificationJson['description']);
      when(mockQueryDocumentSnapshot['dateCreated'])
          .thenReturn(dummyNotificationJson['dateCreated']);

      // Act
      final model = NotificationModel.fromMap(mockQueryDocumentSnapshot);

      // Assert
      expect(model, equals(dummyNotification));
    },
  );

  test(
    'should correctly create NotificationModel from Firestore Document',
    () {
      // Arrange
      when(mockDocumentSnapshot.data()).thenReturn(dummyNotificationJson);
      when(mockDocumentSnapshot['id']).thenReturn(dummyNotificationJson['id']);
      when(mockDocumentSnapshot['title'])
          .thenReturn(dummyNotificationJson['title']);
      when(mockDocumentSnapshot['description'])
          .thenReturn(dummyNotificationJson['description']);
      when(mockDocumentSnapshot['dateCreated'])
          .thenReturn(dummyNotificationJson['dateCreated']);

      // Act
      final model = NotificationModel.fromDocument(mockDocumentSnapshot);

      // Assert
      expect(model, equals(dummyNotification));
    },
  );
}

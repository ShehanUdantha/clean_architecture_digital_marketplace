import 'package:Pixelcart/src/data/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'user_model_test.mocks.dart';

@GenerateMocks([DocumentSnapshot])
void main() {
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

  setUp(() {
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
  });

  test(
    'should correctly convert UserModel to JSON',
    () {
      // Act
      final json = userDetailsDummy.toJson();

      // Assert
      expect(json, userDetailsDummyJson);
    },
  );

  test(
    'should correctly create UserModel from Entity',
    () {
      // Act
      final userFromEntity = UserModel.fromEntity(userDetailsDummyEntity);

      // Assert
      expect(userFromEntity, equals(userDetailsDummy));
    },
  );

  test(
    'should correctly create UserModel from Map',
    () {
      // Act
      final userFromMap = UserModel.fromMap(userDetailsDummyJson);

      // Assert
      expect(userFromMap, equals(userDetailsDummy));
    },
  );

  test(
    'should correctly create UserModel from Firestore Document',
    () {
      // Arrange
      when(mockDocumentSnapshot.data()).thenReturn(userDetailsDummyJson);
      when(mockDocumentSnapshot['userId'])
          .thenReturn(userDetailsDummyJson['userId']);
      when(mockDocumentSnapshot['userType'])
          .thenReturn(userDetailsDummyJson['userType']);
      when(mockDocumentSnapshot['userName'])
          .thenReturn(userDetailsDummyJson['userName']);
      when(mockDocumentSnapshot['email'])
          .thenReturn(userDetailsDummyJson['email']);
      when(mockDocumentSnapshot['password'])
          .thenReturn(userDetailsDummyJson['password']);
      when(mockDocumentSnapshot['deviceToken'])
          .thenReturn(userDetailsDummyJson['deviceToken']);

      // Act
      final model = UserModel.fromDocument(mockDocumentSnapshot);

      // Assert
      expect(model, equals(userDetailsDummy));
    },
  );
}

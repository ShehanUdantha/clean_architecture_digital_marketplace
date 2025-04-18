import 'package:Pixelcart/src/data/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/users_values.dart';
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
      final json = userUserTypeModel.toJson();

      // Assert
      expect(json, userUserTypeJson);
    },
  );

  test(
    'should correctly create UserModel from Entity',
    () {
      // Act
      final userFromEntity = UserModel.fromEntity(userUserTypeEntity);

      // Assert
      expect(userFromEntity, equals(userUserTypeModel));
    },
  );

  test(
    'should correctly create UserModel from Map',
    () {
      // Act
      final userFromMap = UserModel.fromMap(userUserTypeJson);

      // Assert
      expect(userFromMap, equals(userUserTypeModel));
    },
  );

  test(
    'should correctly create UserModel from Firestore Document',
    () {
      // Arrange
      when(mockDocumentSnapshot.data()).thenReturn(userUserTypeJson);
      when(mockDocumentSnapshot['userId'])
          .thenReturn(userUserTypeJson['userId']);
      when(mockDocumentSnapshot['userType'])
          .thenReturn(userUserTypeJson['userType']);
      when(mockDocumentSnapshot['userName'])
          .thenReturn(userUserTypeJson['userName']);
      when(mockDocumentSnapshot['email']).thenReturn(userUserTypeJson['email']);
      when(mockDocumentSnapshot['password'])
          .thenReturn(userUserTypeJson['password']);
      when(mockDocumentSnapshot['deviceToken'])
          .thenReturn(userUserTypeJson['deviceToken']);

      // Act
      final model = UserModel.fromDocument(mockDocumentSnapshot);

      // Assert
      expect(model, equals(userUserTypeModel));
    },
  );
}

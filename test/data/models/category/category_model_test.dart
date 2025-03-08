import 'package:Pixelcart/src/data/models/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'category_model_test.mocks.dart';

@GenerateMocks([QueryDocumentSnapshot])
void main() {
  late MockQueryDocumentSnapshot<Map<String, dynamic>>
      mockQueryDocumentSnapshot;

  setUp(() {
    mockQueryDocumentSnapshot =
        MockQueryDocumentSnapshot<Map<String, dynamic>>();
  });

  test(
    'should correctly convert CategoryModel to JSON',
    () {
      // Act
      final json = dummyCategory.toJson();

      // Assert
      expect(json, dummyCategoryJson);
    },
  );

  test(
    'should correctly create CategoryModel from Entity',
    () {
      // Act
      final categoryFromEntity = CategoryModel.fromEntity(dummyCategoryEntity);

      // Assert
      expect(categoryFromEntity, equals(dummyCategory));
    },
  );

  test(
    'should correctly create CategoryModel from Firestore Query Snapshot',
    () {
      // Arrange
      when(mockQueryDocumentSnapshot.data()).thenReturn(dummyCategoryJson);
      when(mockQueryDocumentSnapshot['id']).thenReturn(dummyCategoryJson['id']);
      when(mockQueryDocumentSnapshot['name'])
          .thenReturn(dummyCategoryJson['name']);
      when(mockQueryDocumentSnapshot['dateCreated'])
          .thenReturn(dummyCategoryJson['dateCreated']);

      // Act
      final model = CategoryModel.fromMap(mockQueryDocumentSnapshot);

      // Assert
      expect(model, equals(dummyCategory));
    },
  );
}

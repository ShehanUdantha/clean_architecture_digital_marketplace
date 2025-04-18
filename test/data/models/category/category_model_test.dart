import 'package:Pixelcart/src/data/models/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/category_values.dart';
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
      final json = fontCategoryModel.toJson();

      // Assert
      expect(json, fontCategoryJson);
    },
  );

  test(
    'should correctly create CategoryModel from Entity',
    () {
      // Act
      final categoryFromEntity = CategoryModel.fromEntity(fontCategoryEntity);

      // Assert
      expect(categoryFromEntity, equals(fontCategoryModel));
    },
  );

  test(
    'should correctly create CategoryModel from Firestore Query Snapshot',
    () {
      // Arrange
      when(mockQueryDocumentSnapshot.data()).thenReturn(fontCategoryJson);
      when(mockQueryDocumentSnapshot['id']).thenReturn(fontCategoryJson['id']);
      when(mockQueryDocumentSnapshot['name'])
          .thenReturn(fontCategoryJson['name']);
      when(mockQueryDocumentSnapshot['dateCreated'])
          .thenReturn(fontCategoryJson['dateCreated']);

      // Act
      final model = CategoryModel.fromMap(mockQueryDocumentSnapshot);

      // Assert
      expect(model, equals(fontCategoryModel));
    },
  );
}

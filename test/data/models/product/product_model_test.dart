import 'package:Pixelcart/src/data/models/product/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/product_values.dart';
import 'product_model_test.mocks.dart';

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
    'should correctly convert ProductModel to JSON',
    () {
      // Act
      final json = productModel.toJson();

      // Assert
      expect(json, productJson);
    },
  );

  test(
    'should correctly create ProductModel from Entity',
    () {
      // Act
      final productFromEntity = ProductModel.fromEntity(productEntity);

      // Assert
      expect(productFromEntity, equals(productModel));
    },
  );

  test(
    'should correctly create ProductModel from Firestore Query Snapshot',
    () {
      // Arrange
      when(mockQueryDocumentSnapshot.data()).thenReturn(productJson);
      when(mockQueryDocumentSnapshot['id']).thenReturn(productJson['id']);
      when(mockQueryDocumentSnapshot['productName'])
          .thenReturn(productJson['productName']);
      when(mockQueryDocumentSnapshot['price']).thenReturn(productJson['price']);
      when(mockQueryDocumentSnapshot['category'])
          .thenReturn(productJson['category']);
      when(mockQueryDocumentSnapshot['marketingType'])
          .thenReturn(productJson['marketingType']);
      when(mockQueryDocumentSnapshot['description'])
          .thenReturn(productJson['description']);
      when(mockQueryDocumentSnapshot['coverImage'])
          .thenReturn(productJson['coverImage']);
      when(mockQueryDocumentSnapshot['subImages'])
          .thenReturn(productJson['subImages']);
      when(mockQueryDocumentSnapshot['zipFile'])
          .thenReturn(productJson['zipFile']);
      when(mockQueryDocumentSnapshot['dateCreated'])
          .thenReturn(productJson['dateCreated']);
      when(mockQueryDocumentSnapshot['likes']).thenReturn(productJson['likes']);
      when(mockQueryDocumentSnapshot['status'])
          .thenReturn(productJson['status']);

      // Act
      final model = ProductModel.fromMap(mockQueryDocumentSnapshot);

      // Assert
      expect(model, equals(productModel));
    },
  );

  test(
    'should correctly create ProductModel from Firestore Document',
    () {
      // Arrange
      when(mockDocumentSnapshot.data()).thenReturn(productJson);
      when(mockDocumentSnapshot['id']).thenReturn(productJson['id']);
      when(mockDocumentSnapshot['productName'])
          .thenReturn(productJson['productName']);
      when(mockDocumentSnapshot['price']).thenReturn(productJson['price']);
      when(mockDocumentSnapshot['category'])
          .thenReturn(productJson['category']);
      when(mockDocumentSnapshot['marketingType'])
          .thenReturn(productJson['marketingType']);
      when(mockDocumentSnapshot['description'])
          .thenReturn(productJson['description']);
      when(mockDocumentSnapshot['coverImage'])
          .thenReturn(productJson['coverImage']);
      when(mockDocumentSnapshot['subImages'])
          .thenReturn(productJson['subImages']);
      when(mockDocumentSnapshot['zipFile']).thenReturn(productJson['zipFile']);
      when(mockDocumentSnapshot['dateCreated'])
          .thenReturn(productJson['dateCreated']);
      when(mockDocumentSnapshot['likes']).thenReturn(productJson['likes']);
      when(mockDocumentSnapshot['status']).thenReturn(productJson['status']);

      // Act
      final model = ProductModel.fromDocument(mockDocumentSnapshot);

      // Assert
      expect(model, equals(productModel));
    },
  );
}

import 'package:Pixelcart/src/data/models/product/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
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
      final json = dummyProduct.toJson();

      // Assert
      expect(json, dummyProductJson);
    },
  );

  test(
    'should correctly create ProductModel from Entity',
    () {
      // Act
      final productFromEntity = ProductModel.fromEntity(dummyProductEntity);

      // Assert
      expect(productFromEntity, equals(dummyProductTwo));
    },
  );

  test(
    'should correctly create ProductModel from Firestore Query Snapshot',
    () {
      // Arrange
      when(mockQueryDocumentSnapshot.data()).thenReturn(dummyProductJson);
      when(mockQueryDocumentSnapshot['id']).thenReturn(dummyProductJson['id']);
      when(mockQueryDocumentSnapshot['productName'])
          .thenReturn(dummyProductJson['productName']);
      when(mockQueryDocumentSnapshot['price'])
          .thenReturn(dummyProductJson['price']);
      when(mockQueryDocumentSnapshot['category'])
          .thenReturn(dummyProductJson['category']);
      when(mockQueryDocumentSnapshot['marketingType'])
          .thenReturn(dummyProductJson['marketingType']);
      when(mockQueryDocumentSnapshot['description'])
          .thenReturn(dummyProductJson['description']);
      when(mockQueryDocumentSnapshot['coverImage'])
          .thenReturn(dummyProductJson['coverImage']);
      when(mockQueryDocumentSnapshot['subImages'])
          .thenReturn(dummyProductJson['subImages']);
      when(mockQueryDocumentSnapshot['zipFile'])
          .thenReturn(dummyProductJson['zipFile']);
      when(mockQueryDocumentSnapshot['dateCreated'])
          .thenReturn(dummyProductJson['dateCreated']);
      when(mockQueryDocumentSnapshot['likes'])
          .thenReturn(dummyProductJson['likes']);
      when(mockQueryDocumentSnapshot['status'])
          .thenReturn(dummyProductJson['status']);

      // Act
      final model = ProductModel.fromMap(mockQueryDocumentSnapshot);

      // Assert
      expect(model, equals(dummyProduct));
    },
  );

  test(
    'should correctly create ProductModel from Firestore Document',
    () {
      // Arrange
      when(mockDocumentSnapshot.data()).thenReturn(dummyProductJson);
      when(mockDocumentSnapshot['id']).thenReturn(dummyProductJson['id']);
      when(mockDocumentSnapshot['productName'])
          .thenReturn(dummyProductJson['productName']);
      when(mockDocumentSnapshot['price']).thenReturn(dummyProductJson['price']);
      when(mockDocumentSnapshot['category'])
          .thenReturn(dummyProductJson['category']);
      when(mockDocumentSnapshot['marketingType'])
          .thenReturn(dummyProductJson['marketingType']);
      when(mockDocumentSnapshot['description'])
          .thenReturn(dummyProductJson['description']);
      when(mockDocumentSnapshot['coverImage'])
          .thenReturn(dummyProductJson['coverImage']);
      when(mockDocumentSnapshot['subImages'])
          .thenReturn(dummyProductJson['subImages']);
      when(mockDocumentSnapshot['zipFile'])
          .thenReturn(dummyProductJson['zipFile']);
      when(mockDocumentSnapshot['dateCreated'])
          .thenReturn(dummyProductJson['dateCreated']);
      when(mockDocumentSnapshot['likes']).thenReturn(dummyProductJson['likes']);
      when(mockDocumentSnapshot['status'])
          .thenReturn(dummyProductJson['status']);

      // Act
      final model = ProductModel.fromDocument(mockDocumentSnapshot);

      // Assert
      expect(model, equals(dummyProduct));
    },
  );
}

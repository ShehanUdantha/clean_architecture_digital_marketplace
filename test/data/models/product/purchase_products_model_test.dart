import 'package:Pixelcart/src/data/models/product/purchase_products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'purchase_products_model_test.mocks.dart';

@GenerateMocks([DocumentSnapshot])
void main() {
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

  setUp(() {
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
  });

  test(
    'should correctly create PurchaseProductsModel from Map',
    () {
      // Act
      final purchaseProductsFromMap =
          PurchaseProductsModel.fromMap(dummyPurchaseProductJson);

      // Assert
      expect(purchaseProductsFromMap, equals(dummyPurchaseProduct));
    },
  );

  test(
    'should correctly create PurchaseProductsModel from Firestore Document',
    () {
      // Arrange
      when(mockDocumentSnapshot.data()).thenReturn(dummyPurchaseProductJson);
      when(mockDocumentSnapshot['purchaseId'])
          .thenReturn(dummyPurchaseProductJson['purchaseId']);
      when(mockDocumentSnapshot['price'])
          .thenReturn(dummyPurchaseProductJson['price']);
      when(mockDocumentSnapshot['date'])
          .thenReturn(dummyPurchaseProductJson['date']);
      when(mockDocumentSnapshot['ids'])
          .thenReturn(dummyPurchaseProductJson['ids']);

      // Act
      final model = PurchaseProductsModel.fromDocument(mockDocumentSnapshot);

      // Assert
      expect(model, equals(dummyPurchaseProduct));
    },
  );
}

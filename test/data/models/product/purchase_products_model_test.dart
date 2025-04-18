import 'package:Pixelcart/src/data/models/product/purchase_products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/purchase_values.dart';
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
          PurchaseProductsModel.fromMap(purchasedProductJson);

      // Assert
      expect(purchaseProductsFromMap, equals(purchasedProductModel));
    },
  );

  test(
    'should correctly create PurchaseProductsModel from Firestore Document',
    () {
      // Arrange
      when(mockDocumentSnapshot.data()).thenReturn(purchasedProductJson);
      when(mockDocumentSnapshot['purchaseId'])
          .thenReturn(purchasedProductJson['purchaseId']);
      when(mockDocumentSnapshot['price'])
          .thenReturn(purchasedProductJson['price']);
      when(mockDocumentSnapshot['date'])
          .thenReturn(purchasedProductJson['date']);
      when(mockDocumentSnapshot['ids']).thenReturn(purchasedProductJson['ids']);

      // Act
      final model = PurchaseProductsModel.fromDocument(mockDocumentSnapshot);

      // Assert
      expect(model, equals(purchasedProductModel));
    },
  );
}

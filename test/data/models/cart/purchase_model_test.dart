import 'package:Pixelcart/src/data/models/cart/purchase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/purchase_values.dart';
import 'purchase_model_test.mocks.dart';

@GenerateMocks([DocumentSnapshot])
void main() {
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

  setUp(() {
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
  });

  test(
    'should correctly create PurchaseModel from Map',
    () {
      // Act
      final purchaseProductsFromMap = PurchaseModel.fromMap(purchasedJson);

      // Assert
      expect(purchaseProductsFromMap, equals(purchasedModel));
    },
  );

  test(
    'should correctly create PurchaseModel from Firestore Document',
    () {
      // Arrange
      when(mockDocumentSnapshot.data()).thenReturn(purchasedJson);
      when(mockDocumentSnapshot['purchaseId'])
          .thenReturn(purchasedJson['purchaseId']);
      when(mockDocumentSnapshot['price']).thenReturn(purchasedJson['price']);
      when(mockDocumentSnapshot['date']).thenReturn(purchasedJson['date']);
      when(mockDocumentSnapshot['ids']).thenReturn(purchasedJson['ids']);

      // Act
      final model = PurchaseModel.fromDocument(mockDocumentSnapshot);

      // Assert
      expect(model, equals(purchasedModel));
    },
  );
}

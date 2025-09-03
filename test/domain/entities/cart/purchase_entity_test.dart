import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/purchase_values.dart';

void main() {
  test(
    'should create a valid Purchase Entity instance',
    () async {
      expect(purchasedEntity.purchaseId, '23434');
      expect(purchasedEntity.price, '2499.98');
      expect(purchasedEntity.dateCreated,
          Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)));
      expect(purchasedEntity.products, [
        'product_003',
        'product_001',
      ]);
    },
  );
}

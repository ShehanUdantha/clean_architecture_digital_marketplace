import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/constant_values.dart';

void main() {
  test(
    'should create a valid Purchase Products Entity instance',
    () async {
      expect(dummyPurchaseProductEntity.purchaseId, '23434');
      expect(dummyPurchaseProductEntity.price, '2000.00');
      expect(dummyPurchaseProductEntity.dateCreated,
          Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)));
      expect(dummyPurchaseProductEntity.products, [
        'product_003',
        'product_001',
      ]);
    },
  );
}

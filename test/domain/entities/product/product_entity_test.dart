import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/constant_values.dart';

void main() {
  test(
    'should create a valid Product Entity instance',
    () async {
      expect(dummyProductEntity.id, null);
      expect(dummyProductEntity.productName, 'Product Four');
      expect(dummyProductEntity.price, '200.00');
      expect(dummyProductEntity.category, 'Mockups');
      expect(dummyProductEntity.marketingType, 'Trending');
      expect(dummyProductEntity.description, 'Product Four description');
      expect(dummyProductEntity.coverImage, 'document/y_1.jpg');
      expect(dummyProductEntity.subImages, [
        'document/y_2.jpg',
        'document/y_3.jpg',
      ]);
      expect(dummyProductEntity.zipFile, 'document/y_4.zip');
      expect(dummyProductEntity.dateCreated, '2025-01-19');
      expect(dummyProductEntity.likes, []);
      expect(dummyProductEntity.status, '');
      expect(dummyProductEntity.sharedSubImages, null);
    },
  );
}

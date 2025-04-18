import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/product_values.dart';

void main() {
  test(
    'should create a valid Product Entity instance',
    () async {
      expect(productEntity.id, 'product_001');
      expect(productEntity.productName, 'Product One');
      expect(productEntity.price, '999.99');
      expect(productEntity.category, 'Mockups');
      expect(productEntity.marketingType, 'Trending');
      expect(productEntity.description, 'Product One description');
      expect(
          productEntity.coverImage, 'https://example.com/images/cover/x_1.jpg');
      expect(productEntity.subImages, [
        'https://example.com/images/sub/x_1.jpg',
        'https://example.com/images/sub/x_2.jpg',
      ]);
      expect(productEntity.zipFile, 'https://example.com/files/x_1.zip');
      expect(productEntity.dateCreated, '2025-01-18');
      expect(productEntity.likes, ['user_01', 'user_02']);
      expect(productEntity.status, 'active');
      expect(productEntity.sharedSubImages, null);
    },
  );
}

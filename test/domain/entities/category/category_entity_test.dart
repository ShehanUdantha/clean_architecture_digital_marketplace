import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/category_values.dart';

void main() {
  test(
    'should create a valid Category Entity instance',
    () async {
      expect(fontCategoryEntity.id, '18976');
      expect(fontCategoryEntity.name, 'Fonts');
      expect(fontCategoryEntity.dateCreated, '2025-01-18');
    },
  );
}

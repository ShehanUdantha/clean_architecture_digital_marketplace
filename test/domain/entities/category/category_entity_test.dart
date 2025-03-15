import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/constant_values.dart';

void main() {
  test(
    'should create a valid Category Entity instance',
    () async {
      expect(dummyCategoryEntity.id, '34534');
      expect(dummyCategoryEntity.name, 'Fonts');
      expect(dummyCategoryEntity.dateCreated, '2025-01-16');
    },
  );
}

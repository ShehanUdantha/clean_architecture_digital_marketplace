import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/constant_values.dart';

void main() {
  test(
    'should create a valid User Entity instance',
    () async {
      expect(userDetailsDummyEntity.userId, 'user_06');
      expect(userDetailsDummyEntity.userType, 'User');
      expect(userDetailsDummyEntity.userName, 'Sam Smith');
      expect(userDetailsDummyEntity.email, 'sam.smith@example.com');
      expect(userDetailsDummyEntity.password, 'password90');
      expect(userDetailsDummyEntity.deviceToken, 'token342');
    },
  );
}

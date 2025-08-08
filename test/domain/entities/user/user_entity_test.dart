import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/users_values.dart';

void main() {
  test(
    'should create a valid User Entity instance',
    () async {
      expect(userUserTypeEntity.userId, 'sampleId890');
      expect(userUserTypeEntity.userType, 'user');
      expect(userUserTypeEntity.userName, 'John Doe');
      expect(userUserTypeEntity.email, 'john.doe@example.com');
      expect(userUserTypeEntity.password, 'password123');
      expect(userUserTypeEntity.deviceToken, 'token123');
    },
  );
}

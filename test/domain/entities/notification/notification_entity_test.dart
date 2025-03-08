import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/constant_values.dart';

void main() {
  test(
    'should create a valid Notification Entity instance',
    () async {
      expect(dummyNotificationEntity.id, null);
      expect(dummyNotificationEntity.title, 'Maintenance Scheduled');
      expect(dummyNotificationEntity.description,
          'We have a scheduled maintenance on January 20th, 2025, from 2 AM to 5 AM.');
      expect(dummyNotificationEntity.dateCreated, '2025-01-19');
    },
  );
}

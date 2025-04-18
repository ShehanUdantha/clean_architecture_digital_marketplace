import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/notification_values.dart';

void main() {
  test(
    'should create a valid Notification Entity instance',
    () async {
      expect(notificationEntity.id, 'notification_002');
      expect(notificationEntity.title, 'Update Available');
      expect(notificationEntity.description,
          'A new version of the app is now available. Update to enjoy the latest features.');
      expect(notificationEntity.dateCreated, '2025-01-18');
    },
  );
}

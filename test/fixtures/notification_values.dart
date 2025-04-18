import 'package:Pixelcart/src/data/models/notification/notification_model.dart';
import 'package:Pixelcart/src/domain/entities/notification/notification_entity.dart';

const String notificationTitleToSend = 'Maintenance Scheduled';
const String notificationDescriptionToSend =
    'We have a scheduled maintenance on January 20th, 2025, from 2 AM to 5 AM.';

const notificationEntityToSend = NotificationEntity(
  title: notificationTitleToSend,
  description: notificationDescriptionToSend,
);

const notificationEntities = [
  NotificationEntity(
    id: 'notification_001',
    title: 'Welcome to the App!',
    description:
        'Thank you for signing up. Explore the features and enjoy your journey with us.',
    dateCreated: '2025-01-15',
  ),
  NotificationEntity(
    id: 'notification_002',
    title: 'Update Available',
    description:
        'A new version of the app is now available. Update to enjoy the latest features.',
    dateCreated: '2025-01-18',
  ),
];

const String notificationId = 'notification_001';

const int currentUserNotificationCount = 2;
const int currentUserNotificationNewCount = 1;

const NotificationEntity notificationEntity = NotificationEntity(
  id: 'notification_002',
  title: 'Update Available',
  description:
      'A new version of the app is now available. Update to enjoy the latest features.',
  dateCreated: '2025-01-18',
);

const NotificationModel notificationModel = NotificationModel(
  id: 'notification_002',
  title: 'Update Available',
  description:
      'A new version of the app is now available. Update to enjoy the latest features.',
  dateCreated: '2025-01-18',
);

const notificationJson = {
  'id': 'notification_002',
  'title': 'Update Available',
  'description':
      'A new version of the app is now available. Update to enjoy the latest features.',
  'dateCreated': '2025-01-18',
};

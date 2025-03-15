import '../../entities/notification/notification_entity.dart';

class SendNotificationParams {
  final NotificationEntity notification;
  final String userId;

  const SendNotificationParams({
    required this.notification,
    required this.userId,
  });
}

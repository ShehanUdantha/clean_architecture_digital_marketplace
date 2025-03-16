import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/notification/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, String>> sendNotification(
      NotificationEntity notification);
  Future<Either<Failure, List<NotificationEntity>>> getAllNotifications();
  Future<Either<Failure, String>> deleteNotification(String notificationId);
}

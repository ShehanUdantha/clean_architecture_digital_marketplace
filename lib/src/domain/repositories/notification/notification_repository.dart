import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/notification/notification_entity.dart';
import '../../usecases/notification/delete_notification_params.dart';
import '../../usecases/notification/send_notification_params.dart';

abstract class NotificationRepository {
  Future<Either<Failure, String>> sendNotification(
      SendNotificationParams sendNotificationParams);
  Future<Either<Failure, List<NotificationEntity>>> getAllNotifications();
  Future<Either<Failure, String>> deleteNotification(
      DeleteNotificationParams deleteNotificationParams);
}

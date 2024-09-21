import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';

abstract class NotificationCountRepository {
  Future<Either<Failure, int>> updateNotificationCount(String userId);
  Future<Either<Failure, int>> getNotificationCount(String userId);
  Future<Either<Failure, String>> resetNotificationCount(String userId);
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exception.dart';
import '../../../domain/repositories/notification/notification_count_repository.dart';
import '../../data_sources/local/notification/notification_local_data_source.dart';

class NotificationCountRepositoryImpl implements NotificationCountRepository {
  final NotificationLocalDataSource notificationLocalDataSource;

  NotificationCountRepositoryImpl({
    required this.notificationLocalDataSource,
  });

  @override
  Future<Either<Failure, int>> getNotificationCount(String userId) async {
    try {
      final result =
          await notificationLocalDataSource.getNotificationCount(userId);
      return Right(result);
    } on DBException catch (e) {
      return Left(
        LocalDBFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> resetNotificationCount(String userId) async {
    try {
      final result =
          await notificationLocalDataSource.resetNotificationCount(userId);
      return Right(result);
    } on DBException catch (e) {
      return Left(
        LocalDBFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, int>> updateNotificationCount(String userId) async {
    try {
      final result =
          await notificationLocalDataSource.updateNotificationCount(userId);
      return Right(result);
    } on DBException catch (e) {
      return Left(
        LocalDBFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }
}

import '../../data_sources/remote/notification/notification_remote_data_source.dart';
import '../../../domain/entities/notification/notification_entity.dart';
import '../../../domain/repositories/notification/notification_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;

  NotificationRepositoryImpl({required this.notificationRemoteDataSource});

  @override
  Future<Either<Failure, String>> sendNotification(
      NotificationEntity notificationEntity) async {
    try {
      final result = await notificationRemoteDataSource
          .sendNotification(notificationEntity);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    } on APIException catch (e) {
      return Left(APIFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> deleteNotification(String id) async {
    try {
      final result = await notificationRemoteDataSource.deleteNotification(id);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>>
      getAllNotifications() async {
    try {
      final result = await notificationRemoteDataSource.getAllNotifications();
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }
}

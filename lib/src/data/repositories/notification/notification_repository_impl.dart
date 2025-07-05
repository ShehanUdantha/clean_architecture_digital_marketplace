// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:dartz/dartz.dart';

import 'package:Pixelcart/src/core/services/network_service.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/notification/notification_entity.dart';
import '../../../domain/repositories/notification/notification_repository.dart';
import '../../data_sources/remote/notification/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;
  final NetworkService networkService;

  NotificationRepositoryImpl({
    required this.notificationRemoteDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Failure, String>> sendNotification(
      NotificationEntity notification) async {
    try {
      if (!await (networkService.isConnected())) {
        return Left(
          NetworkFailure(
            errorMessage: rootNavigatorKey.currentContext != null
                ? rootNavigatorKey.currentContext!.loc.noInternetMessage
                : AppErrorMessages.noInternetMessage,
          ),
        );
      }

      final result =
          await notificationRemoteDataSource.sendNotification(notification);
      return Right(result);
    } on AuthException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    } on DBException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    } on APIException catch (e) {
      return Left(
        APIFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> deleteNotification(
      String notificationId) async {
    try {
      if (!await (networkService.isConnected())) {
        return Left(
          NetworkFailure(
            errorMessage: rootNavigatorKey.currentContext != null
                ? rootNavigatorKey.currentContext!.loc.noInternetMessage
                : AppErrorMessages.noInternetMessage,
          ),
        );
      }

      final result =
          await notificationRemoteDataSource.deleteNotification(notificationId);
      return Right(result);
    } on AuthException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    } on DBException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>>
      getAllNotifications() async {
    try {
      if (!await (networkService.isConnected())) {
        return Left(
          NetworkFailure(
            errorMessage: rootNavigatorKey.currentContext != null
                ? rootNavigatorKey.currentContext!.loc.noInternetMessage
                : AppErrorMessages.noInternetMessage,
          ),
        );
      }

      final result = await notificationRemoteDataSource.getAllNotifications();
      return Right(result);
    } on AuthException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    } on DBException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }
}

import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/local/notification/notification_local_data_source.dart';
import 'package:Pixelcart/src/data/repositories/notification/notification_count_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'notification_count_repository_impl_test.mocks.dart';

@GenerateMocks([NotificationLocalDataSource])
void main() {
  late NotificationCountRepositoryImpl notificationCountRepositoryImpl;
  late MockNotificationLocalDataSource mockNotificationLocalDataSource;

  setUp(() {
    mockNotificationLocalDataSource = MockNotificationLocalDataSource();
    notificationCountRepositoryImpl = NotificationCountRepositoryImpl(
        notificationLocalDataSource: mockNotificationLocalDataSource);
  });

  group(
    'getNotificationCount',
    () {
      test(
        'should return a Notification count when the get notification count process is successful',
        () async {
          // Arrange
          when(mockNotificationLocalDataSource
                  .getNotificationCount(dummyUserIdToGetNotifications))
              .thenAnswer((_) async => fakeNotificationCount);

          // Act
          final result = await notificationCountRepositoryImpl
              .getNotificationCount(dummyUserIdToGetNotifications);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, fakeNotificationCount),
          );
        },
      );

      test(
        'should return a Failure when the get notification count process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get notification count failed',
          );
          when(mockNotificationLocalDataSource
                  .getNotificationCount(dummyUserIdToGetNotifications))
              .thenThrow(dbException);

          // Act
          final result = await notificationCountRepositoryImpl
              .getNotificationCount(dummyUserIdToGetNotifications);

          // Assert
          final failure = LocalDBFailure(
            errorMessage: 'Get notification count failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'resetNotificationCount',
    () {
      test(
        'should return a Success Status when the reset notification count process is successful',
        () async {
          // Arrange
          when(mockNotificationLocalDataSource
                  .resetNotificationCount(dummyUserIdToGetNotifications))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await notificationCountRepositoryImpl
              .resetNotificationCount(dummyUserIdToGetNotifications);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the reset notification count process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Reset notification count failed',
          );
          when(mockNotificationLocalDataSource
                  .resetNotificationCount(dummyUserIdToGetNotifications))
              .thenThrow(dbException);

          // Act
          final result = await notificationCountRepositoryImpl
              .resetNotificationCount(dummyUserIdToGetNotifications);

          // Assert
          final failure = LocalDBFailure(
            errorMessage: 'Reset notification count failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'updateNotificationCount',
    () {
      test(
        'should return a New notification count when the update notification count process is successful',
        () async {
          // Arrange
          when(mockNotificationLocalDataSource
                  .updateNotificationCount(dummyUserIdToGetNotifications))
              .thenAnswer((_) async => fakeNotificationNewCount);

          // Act
          final result = await notificationCountRepositoryImpl
              .updateNotificationCount(dummyUserIdToGetNotifications);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, fakeNotificationNewCount),
          );
        },
      );

      test(
        'should return a Failure when the update notification count process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Update notification count failed',
          );
          when(mockNotificationLocalDataSource
                  .updateNotificationCount(dummyUserIdToGetNotifications))
              .thenThrow(dbException);

          // Act
          final result = await notificationCountRepositoryImpl
              .updateNotificationCount(dummyUserIdToGetNotifications);

          // Assert
          final failure = LocalDBFailure(
            errorMessage: 'Update notification count failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );
}

import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/local/notification/notification_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/auth_values.dart';
import '../../../../fixtures/notification_values.dart';
import 'notification_local_data_source_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBox mockNotificationBox;
  late NotificationLocalDataSource notificationLocalDataSource;

  setUp(() async {
    mockNotificationBox = MockBox();

    notificationLocalDataSource = NotificationLocalDataSourceImpl(
      notificationBox: mockNotificationBox,
    );
  });

  group(
    'getNotificationCount',
    () {
      test(
        'should return a Notification count when fetching notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.get(userUserId))
              .thenAnswer((_) async => currentUserNotificationCount);

          // Act
          final result = await notificationLocalDataSource
              .getNotificationCount(userUserId);

          // Assert
          expect(result, currentUserNotificationCount);
        },
      );

      test(
        'should return a Zero when no notification count is found for the user id',
        () async {
          // Arrange
          when(mockNotificationBox.get(userUserId)).thenAnswer((_) => null);

          // Act
          final result = await notificationLocalDataSource
              .getNotificationCount(userUserId);

          // Assert
          expect(result, 0);
        },
      );

      test(
        'should throw DBException if HiveError occurs while fetching notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.get(userUserId)).thenThrow(
            HiveError('Box closed'),
          );

          // Act & Assert
          await expectLater(
            () => notificationLocalDataSource.getNotificationCount(userUserId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                'HiveError: Box closed',
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException if an other error occurs while fetching notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.get(userUserId)).thenThrow(
            DBException(errorMessage: 'Unexpected error'),
          );

          // Act & Assert
          await expectLater(
            () => notificationLocalDataSource.getNotificationCount(userUserId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                'Unexpected error',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'resetNotificationCount',
    () {
      test(
        'should return a Success Status when resetting the notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.put(userUserId, 0))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await notificationLocalDataSource
              .resetNotificationCount(userUserId);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should throw DBException if HiveError occurs while resetting the notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.put(userUserId, 0)).thenThrow(
            HiveError('Box closed'),
          );

          // Act & Assert
          await expectLater(
            () =>
                notificationLocalDataSource.resetNotificationCount(userUserId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                'HiveError: Box closed',
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException if an other error occurs while resetting the notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.put(userUserId, 0)).thenThrow(
            DBException(errorMessage: 'Unexpected error'),
          );

          // Act & Assert
          await expectLater(
            () =>
                notificationLocalDataSource.resetNotificationCount(userUserId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                'Unexpected error',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'updateNotificationCount',
    () {
      test(
        'should return a New notification count when a previous count exists while updating the notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.get(userUserId))
              .thenAnswer((_) async => currentUserNotificationCount);

          when(mockNotificationBox.put(
                  userUserId, currentUserNotificationNewCountWithPreviousCount))
              .thenAnswer((_) async => Future.value());

          // Act
          final result = await notificationLocalDataSource
              .updateNotificationCount(userUserId);

          // Assert
          expect(result, currentUserNotificationNewCountWithPreviousCount);
        },
      );

      test(
        'should return a New notification count when a no previous count exists while updating the notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.get(userUserId))
              .thenAnswer((_) async => null);

          when(mockNotificationBox.put(userUserId,
                  currentUserNotificationNewCountWithOutPreviousCount))
              .thenAnswer((_) async => Future.value());

          // Act
          final result = await notificationLocalDataSource
              .updateNotificationCount(userUserId);

          // Assert
          expect(result, currentUserNotificationNewCountWithOutPreviousCount);
        },
      );

      test(
        'should throw DBException if HiveError occurs while updating the notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.get(userUserId))
              .thenAnswer((_) async => currentUserNotificationCount);

          when(mockNotificationBox.put(
                  userUserId, currentUserNotificationNewCountWithPreviousCount))
              .thenThrow(
            HiveError('Box closed'),
          );

          // Act & Assert
          await expectLater(
            () =>
                notificationLocalDataSource.updateNotificationCount(userUserId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                'HiveError: Box closed',
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException if an other error occurs while updating the notification count by user id',
        () async {
          // Arrange
          when(mockNotificationBox.get(userUserId))
              .thenAnswer((_) async => currentUserNotificationCount);

          when(mockNotificationBox.put(
                  userUserId, currentUserNotificationNewCountWithPreviousCount))
              .thenThrow(
            DBException(errorMessage: 'Unexpected error'),
          );

          // Act & Assert
          await expectLater(
            () =>
                notificationLocalDataSource.updateNotificationCount(userUserId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                'Unexpected error',
              ),
            ),
          );
        },
      );
    },
  );
}

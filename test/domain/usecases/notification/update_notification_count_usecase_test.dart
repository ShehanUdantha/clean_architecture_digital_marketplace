import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/notification/notification_count_repository.dart';
import 'package:Pixelcart/src/domain/usecases/notification/update_notification_count_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'update_notification_count_usecase_test.mocks.dart';

@GenerateMocks([NotificationCountRepository])
void main() {
  late UpdateNotificationCountUseCase updateNotificationCountUseCase;
  late MockNotificationCountRepository mockNotificationCountRepository;

  setUp(() {
    mockNotificationCountRepository = MockNotificationCountRepository();
    updateNotificationCountUseCase = UpdateNotificationCountUseCase(
        notificationCountRepository: mockNotificationCountRepository);
  });

  test(
    'should return a New notification count when the update notification count process is successful',
    () async {
      // Arrange
      when(mockNotificationCountRepository
              .updateNotificationCount(dummyUserIdToGetNotifications))
          .thenAnswer((_) async => Right(fakeNotificationNewCount));

      // Act
      final result = await updateNotificationCountUseCase
          .call(dummyUserIdToGetNotifications);

      // Assert
      expect(result, Right(fakeNotificationNewCount));
    },
  );

  test(
    'should return a Failure when the update notification count process fails',
    () async {
      // Arrange
      final failure = LocalDBFailure(
        errorMessage: 'Update notification count failed',
      );
      when(mockNotificationCountRepository
              .updateNotificationCount(dummyUserIdToGetNotifications))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await updateNotificationCountUseCase
          .call(dummyUserIdToGetNotifications);

      // Assert
      expect(result, Left(failure));
    },
  );
}

import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/notification/notification_count_repository.dart';
import 'package:Pixelcart/src/domain/usecases/notification/reset_notification_count_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'reset_notification_count_usecase_test.mocks.dart';

@GenerateMocks([NotificationCountRepository])
void main() {
  late ResetNotificationCountUseCase resetNotificationCountUseCase;
  late MockNotificationCountRepository mockNotificationCountRepository;

  setUp(() {
    mockNotificationCountRepository = MockNotificationCountRepository();
    resetNotificationCountUseCase = ResetNotificationCountUseCase(
        notificationCountRepository: mockNotificationCountRepository);
  });

  test(
    'should return a Success Status when the reset notification count process is successful',
    () async {
      // Arrange
      when(mockNotificationCountRepository
              .resetNotificationCount(dummyUserIdToGetNotifications))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await resetNotificationCountUseCase
          .call(dummyUserIdToGetNotifications);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the reset notification count process fails',
    () async {
      // Arrange
      final failure = LocalDBFailure(
        errorMessage: 'Reset notification count failed',
      );
      when(mockNotificationCountRepository
              .resetNotificationCount(dummyUserIdToGetNotifications))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await resetNotificationCountUseCase
          .call(dummyUserIdToGetNotifications);

      // Assert
      expect(result, Left(failure));
    },
  );
}

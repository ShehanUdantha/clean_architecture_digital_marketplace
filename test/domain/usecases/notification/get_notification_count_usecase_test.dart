import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/notification/notification_count_repository.dart';
import 'package:Pixelcart/src/domain/usecases/notification/get_notification_count_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'get_notification_count_usecase_test.mocks.dart';

@GenerateMocks([NotificationCountRepository])
void main() {
  late GetNotificationCountUseCase getNotificationCountUseCase;
  late MockNotificationCountRepository mockNotificationCountRepository;

  setUp(() {
    mockNotificationCountRepository = MockNotificationCountRepository();
    getNotificationCountUseCase = GetNotificationCountUseCase(
        notificationCountRepository: mockNotificationCountRepository);
  });

  test(
    'should return a Notification count when the get notification count process is successful',
    () async {
      // Arrange
      when(mockNotificationCountRepository
              .getNotificationCount(dummyUserIdToGetNotifications))
          .thenAnswer((_) async => Right(fakeNotificationCount));

      // Act
      final result =
          await getNotificationCountUseCase.call(dummyUserIdToGetNotifications);

      // Assert
      expect(result, Right(fakeNotificationCount));
    },
  );

  test(
    'should return a Failure when the get notification count process fails',
    () async {
      // Arrange
      final failure = LocalDBFailure(
        errorMessage: 'Get notification count failed',
      );
      when(mockNotificationCountRepository
              .getNotificationCount(dummyUserIdToGetNotifications))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getNotificationCountUseCase.call(dummyUserIdToGetNotifications);

      // Assert
      expect(result, Left(failure));
    },
  );
}

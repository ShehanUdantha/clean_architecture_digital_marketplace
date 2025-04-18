import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/usecases/usecase.dart';
import 'package:Pixelcart/src/domain/repositories/notification/notification_repository.dart';
import 'package:Pixelcart/src/domain/usecases/notification/get_all_notifications_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/notification_values.dart';
import 'get_all_notifications_usecase_test.mocks.dart';

@GenerateMocks([NotificationRepository])
void main() {
  late GetAllNotificationsUseCase getAllNotificationsUseCase;
  late MockNotificationRepository mockNotificationRepository;

  setUp(() {
    mockNotificationRepository = MockNotificationRepository();
    getAllNotificationsUseCase = GetAllNotificationsUseCase(
        notificationRepository: mockNotificationRepository);
  });

  test(
    'should return a List of notifications when the get all notifications process is successful',
    () async {
      // Arrange
      when(mockNotificationRepository.getAllNotifications())
          .thenAnswer((_) async => Right(notificationEntities));

      // Act
      final result = await getAllNotificationsUseCase.call(NoParams());

      // Assert
      expect(result, Right(notificationEntities));
    },
  );

  test(
    'should return a Failure when the get all notifications process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all notifications failed',
      );
      when(mockNotificationRepository.getAllNotifications())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllNotificationsUseCase.call(NoParams());

      // Assert
      expect(result, Left(failure));
    },
  );
}

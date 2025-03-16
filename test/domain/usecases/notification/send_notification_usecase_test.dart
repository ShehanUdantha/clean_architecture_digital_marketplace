import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/notification/notification_repository.dart';
import 'package:Pixelcart/src/domain/usecases/notification/send_notification_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'send_notification_usecase_test.mocks.dart';

@GenerateMocks([NotificationRepository])
void main() {
  late SendNotificationUseCase sendNotificationUseCase;
  late MockNotificationRepository mockNotificationRepository;

  setUp(() {
    mockNotificationRepository = MockNotificationRepository();
    sendNotificationUseCase = SendNotificationUseCase(
        notificationRepository: mockNotificationRepository);
  });

  test(
    'should return a Success Status when the send notification process is successful',
    () async {
      // Arrange
      when(mockNotificationRepository.sendNotification(dummyNotificationEntity))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result =
          await sendNotificationUseCase.call(dummyNotificationEntity);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the send notification process fails - (Firebase)',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Send notification failed - (Firebase)',
      );
      when(mockNotificationRepository.sendNotification(dummyNotificationEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await sendNotificationUseCase.call(dummyNotificationEntity);

      // Assert
      expect(result, Left(failure));
    },
  );

  test(
    'should return a Failure when the send notification process fails - (API)',
    () async {
      // Arrange
      final failure = APIFailure(
        errorMessage: 'Send notification failed - (API)',
      );
      when(mockNotificationRepository.sendNotification(dummyNotificationEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await sendNotificationUseCase.call(dummyNotificationEntity);

      // Assert
      expect(result, Left(failure));
    },
  );
}

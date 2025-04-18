import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/notification/notification_repository.dart';
import 'package:Pixelcart/src/domain/usecases/notification/delete_notification_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/notification_values.dart';
import 'delete_notification_usecase_test.mocks.dart';

@GenerateMocks([NotificationRepository])
void main() {
  late DeleteNotificationUseCase deleteNotificationUseCase;
  late MockNotificationRepository mockNotificationRepository;

  setUp(() {
    mockNotificationRepository = MockNotificationRepository();
    deleteNotificationUseCase = DeleteNotificationUseCase(
        notificationRepository: mockNotificationRepository);
  });

  test(
    'should return a Success Status when the delete notification process is successful',
    () async {
      // Arrange
      when(mockNotificationRepository.deleteNotification(notificationId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await deleteNotificationUseCase.call(notificationId);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the delete notification process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Delete notification failed',
      );
      when(mockNotificationRepository.deleteNotification(notificationId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await deleteNotificationUseCase.call(notificationId);

      // Assert
      expect(result, Left(failure));
    },
  );
}

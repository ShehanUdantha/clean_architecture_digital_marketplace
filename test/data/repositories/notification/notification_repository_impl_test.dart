import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/services/network_service.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/notification/notification_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/notification/notification_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/notification_values.dart';
import 'notification_repository_impl_test.mocks.dart';

@GenerateMocks([NotificationRemoteDataSource, NetworkService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NotificationRepositoryImpl notificationRepositoryImpl;
  late MockNotificationRemoteDataSource mockNotificationRemoteDataSource;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockNotificationRemoteDataSource = MockNotificationRemoteDataSource();
    mockNetworkService = MockNetworkService();
    notificationRepositoryImpl = NotificationRepositoryImpl(
      notificationRemoteDataSource: mockNotificationRemoteDataSource,
      networkService: mockNetworkService,
    );
  });

  group(
    'sendNotification',
    () {
      test(
        'should return a Success Status when the send notification process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockNotificationRemoteDataSource
                  .sendNotification(notificationEntityToSend))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await notificationRepositoryImpl
              .sendNotification(notificationEntityToSend);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the send notification process fails - (Firebase)',
        () async {
          // Arrange
          final dBException = DBException(
            errorMessage: 'Send notification failed - (Firebase)',
          );
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockNotificationRemoteDataSource
                  .sendNotification(notificationEntityToSend))
              .thenThrow(dBException);

          // Act
          final result = await notificationRepositoryImpl
              .sendNotification(notificationEntityToSend);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Send notification failed - (Firebase)',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when the send notification process fails - (API)',
        () async {
          // Arrange
          final apiException = APIException(
            errorMessage: 'Send notification failed - (API)',
          );
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockNotificationRemoteDataSource
                  .sendNotification(notificationEntityToSend))
              .thenThrow(apiException);

          // Act
          final result = await notificationRepositoryImpl
              .sendNotification(notificationEntityToSend);

          // Assert
          final failure = APIFailure(
            errorMessage: 'Send notification failed - (API)',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the send notification process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await notificationRepositoryImpl
              .sendNotification(notificationEntityToSend);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'deleteNotification',
    () {
      test(
        'should return a Success Status when the delete notification process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockNotificationRemoteDataSource
                  .deleteNotification(notificationId))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await notificationRepositoryImpl
              .deleteNotification(notificationId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the delete notification process fails',
        () async {
          // Arrange
          final dBException = DBException(
            errorMessage: 'Delete notification failed',
          );
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockNotificationRemoteDataSource
                  .deleteNotification(notificationId))
              .thenThrow(dBException);

          // Act
          final result = await notificationRepositoryImpl
              .deleteNotification(notificationId);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Delete notification failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the delete notification process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await notificationRepositoryImpl
              .deleteNotification(notificationId);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAllNotifications',
    () {
      test(
        'should return a List of notifications when the get all notifications process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockNotificationRemoteDataSource.getAllNotifications())
              .thenAnswer((_) async => notificationEntities);

          // Act
          final result = await notificationRepositoryImpl.getAllNotifications();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, notificationEntities),
          );
        },
      );

      test(
        'should return a Failure when the get all notifications process fails',
        () async {
          // Arrange
          final dBException = DBException(
            errorMessage: 'Get all notifications failed',
          );
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockNotificationRemoteDataSource.getAllNotifications())
              .thenThrow(dBException);

          // Act
          final result = await notificationRepositoryImpl.getAllNotifications();

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all notifications failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the get all notifications process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await notificationRepositoryImpl.getAllNotifications();

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );
}

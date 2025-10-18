import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/notification/notification_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/auth_values.dart';
import '../../../../fixtures/notification_values.dart';
import 'notification_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  CollectionReference,
  User,
  http.Client,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late NotificationRemoteDataSource notificationRemoteDataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    mockHttpClient = MockClient();

    notificationRemoteDataSource = NotificationRemoteDataSourceImpl(
      auth: mockFirebaseAuth,
      fireStore: fakeFirebaseFirestore,
      client: mockHttpClient,
    );
  });

  // TODO: need to implement
  // group(
  //   'sendNotification',
  //   () {},
  // );

  group(
    'deleteNotification',
    () {
      test(
        'should return a Success Status when deleting a notification from the notification list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Add notification data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.notifications)
              .doc(notificationId)
              .set(notificationJson);

          // Act
          final result = await notificationRemoteDataSource
              .deleteNotification(notificationId);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should throw AuthException when the user is not found',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act & Assert
          await expectLater(
            () =>
                notificationRemoteDataSource.deleteNotification(notificationId),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.userNotFound,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException when a non-admin user attempts to delete the notification from the notification list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          // Act & Assert
          await expectLater(
            () =>
                notificationRemoteDataSource.deleteNotification(notificationId),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.unauthorizedAccess,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if an error occurs while deleting a notification from the notification list',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.currentUser,
          ).thenThrow(
            FirebaseAuthException(
              code: 'unknown',
              message: AppErrorMessages.authenticationErrorOccurred,
            ),
          );

          // Act & Assert
          await expectLater(
            () =>
                notificationRemoteDataSource.deleteNotification(notificationId),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                '[firebase_auth/unknown] ${AppErrorMessages.authenticationErrorOccurred}',
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException when a database operation fails while deleting a notification from the notification list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Add notification data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(notificationId)
              .set(notificationJson);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.notifications)
              .doc(notificationId);

          whenCalling(Invocation.method(#delete, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Delete notification failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () =>
                notificationRemoteDataSource.deleteNotification(notificationId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Delete notification failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllNotifications',
    () {
      test(
        'should return a List of Notification when fetching notification data',
        () async {
          // Arrange
          // Add notifications to FakeFirestore
          for (final model in notificationModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.notifications)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result =
              await notificationRemoteDataSource.getAllNotifications();

          // Assert
          expect(result, notificationModels);
        },
      );

      test(
        'should throw DBException when a database operation fails while fetching notification data',
        () async {
          // Arrange
          final mockFirestore = MockFirebaseFirestore();

          final CollectionReference<Map<String, dynamic>>
              mockNotificationsCollection = MockCollectionReference();

          when(mockFirestore.collection(AppVariableNames.notifications))
              .thenReturn(mockNotificationsCollection);

          when(mockNotificationsCollection.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Get all notifications failed',
            ),
          );

          final notificationRemoteDataSource = NotificationRemoteDataSourceImpl(
            auth: mockFirebaseAuth,
            fireStore: mockFirestore,
            client: mockHttpClient,
          );

          // Act & Assert
          await expectLater(
            () => notificationRemoteDataSource.getAllNotifications(),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get all notifications failed',
              ),
            ),
          );
        },
      );
    },
  );
}

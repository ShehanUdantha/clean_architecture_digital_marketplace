import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/data/data_sources/remote/user/user_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/auth_values.dart';
import '../../../../fixtures/users_values.dart';
import 'user_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Query,
  User
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late UserRemoteDataSource userRemoteDataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirebaseFirestore = FakeFirebaseFirestore();

    userRemoteDataSource = UserRemoteDataSourceImpl(
      auth: mockFirebaseAuth,
      fireStore: fakeFirebaseFirestore,
    );
  });

  group(
    'getUserType',
    () {
      test(
        'should return a User Type when fetching user type by user id',
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

          // Act
          final result = await userRemoteDataSource.getUserType(userUserId);

          // Assert
          expect(result, userTypeForUser.toLowerCase());
        },
      );

      test(
        'should throw AuthException when the user is not found',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act & Assert
          await expectLater(
            () => userRemoteDataSource.getUserType(userUserId),
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
        'should throw DBException when a database operation fails while fetching user type by user id',
        () async {
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Get user type by user id failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => userRemoteDataSource.getUserType(userUserId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get user type by user id failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getUserDetails',
    () {
      test(
        'should return a Current user details when fetching user details by id',
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

          // Act
          final result = await userRemoteDataSource.getUserDetails();

          // Assert
          expect(result, userUserModel);
        },
      );

      test(
        'should throw AuthException when the user is not found',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act & Assert
          await expectLater(
            () => userRemoteDataSource.getUserDetails(),
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
        'should throw DBException when a database operation fails while fetching user details by id',
        () async {
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Get user details by id failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => userRemoteDataSource.getUserDetails(),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get user details by id failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllUsers',
    () {
      test(
        'should return an All type of users when fetching all users data (All Account)',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add users data to FakeFirestore
          for (final model in allTypeOfUserModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.users)
                .doc(model.userId)
                .set(model.toJson());
          }

          // Act
          final result = await userRemoteDataSource.getAllUsers(userTypeForAll);

          // Assert
          expect(result, allTypeOfUserModels);
        },
      );

      test(
        'should return an Only Users when fetching all users data with userType set to (User)',
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

          // Add users data to FakeFirestore
          for (final model in onlyUserModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.users)
                .doc(model.userId)
                .set(model.toJson());
          }

          // Act
          final result =
              await userRemoteDataSource.getAllUsers(userTypeForUser);

          // Assert
          expect(result, onlyUserModels);
        },
      );

      test(
        'should return an Only Admins when fetching all users data with userType set to (Admin)',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add users data to FakeFirestore
          for (final model in onlyAdminModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.users)
                .doc(model.userId)
                .set(model.toJson());
          }

          // Act
          final result =
              await userRemoteDataSource.getAllUsers(userTypeForAdmin);

          // Assert
          expect(result, onlyAdminModels);
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
            () => userRemoteDataSource.getAllUsers(userTypeForAll),
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
        'should throw AuthException when a non-admin user attempts to fetch all users data',
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
            () => userRemoteDataSource.getAllUsers(userTypeForAll),
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
        'should throw AuthException if an error occurs while fetching all users data',
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
            () => userRemoteDataSource.getAllUsers(userTypeForAll),
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
        'should throw DBException when a database operation fails while fetching all users data',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          final mockFirestore = MockFirebaseFirestore();
          final DocumentReference<Map<String, dynamic>> mockUserDocRef =
              MockDocumentReference();
          final DocumentSnapshot<Map<String, dynamic>> mockUserDocSnapshot =
              MockDocumentSnapshot();
          final CollectionReference<Map<String, dynamic>> mockUserCollection =
              MockCollectionReference();
          final Query<Map<String, dynamic>> mockUsersQuery = MockQuery();

          when(mockFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollection);
          when(mockUserCollection.doc(userAdminId)).thenReturn(mockUserDocRef);
          when(mockUserDocRef.get())
              .thenAnswer((_) async => mockUserDocSnapshot);
          when(mockUserDocSnapshot.exists).thenReturn(true);
          when(mockUserDocSnapshot.data()).thenReturn(userAdminModel.toJson());

          when(mockUserCollection.where('userType',
                  isEqualTo: userTypeForAdmin.toLowerCase()))
              .thenReturn(mockUsersQuery);

          when(mockUsersQuery.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Add all admin users failed',
            ),
          );

          final userRemoteDataSource = UserRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
          );

          // Act & Assert
          await expectLater(
            () => userRemoteDataSource.getAllUsers(userTypeForAdmin),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Add all admin users failed',
              ),
            ),
          );
        },
      );
    },
  );
}

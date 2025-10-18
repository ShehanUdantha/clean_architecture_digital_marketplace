import 'dart:async';

import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/auth/user_auth_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/auth_values.dart';
import 'user_auth_remote_data_source_test.mocks.dart';

@GenerateMocks([FirebaseAuth, FirebaseMessaging, UserCredential, User])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late MockFirebaseMessaging mockFirebaseMessaging;
  late UserAuthRemoteDataSourceImpl authRemoteDataSource;

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    mockFirebaseMessaging = MockFirebaseMessaging();

    authRemoteDataSource = UserAuthRemoteDataSourceImpl(
      auth: mockFirebaseAuth,
      fireStore: fakeFirebaseFirestore,
      firebaseMessaging: mockFirebaseMessaging,
    );
  });

  group(
    'signInUser',
    () {
      test(
        'should return a User Id and update the device token after sign-in',
        () async {
          // Arrange
          final mockUser = MockUser();
          final mockUserCredential = MockUserCredential();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockUserCredential.user).thenReturn(mockUser);

          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: userSignInParams.email,
              password: userSignInParams.password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          when(mockFirebaseMessaging.getToken())
              .thenAnswer((_) async => userUserModel.deviceToken);

          // Act
          final result =
              await authRemoteDataSource.signInUser(userSignInParams);

          // Assert
          expect(result!.uid, userUserId);

          final snap = await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .get();

          expect(snap.data()!['deviceToken'], userUserModel.deviceToken);

          verify(mockFirebaseAuth.signInWithEmailAndPassword(
            email: userSignInParams.email,
            password: userSignInParams.password,
          )).called(1);

          verify(mockFirebaseMessaging.getToken()).called(1);
        },
      );

      test(
        'should throw AuthException when userCredential.user is null during sign-in',
        () async {
          // Arrange
          final MockUserCredential nullUserCredential = MockUserCredential();
          when(nullUserCredential.user).thenReturn(null);

          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: userSignInParams.email,
              password: userSignInParams.password,
            ),
          ).thenAnswer((_) async => nullUserCredential);

          // Act & Assert
          expect(
            () => authRemoteDataSource.signInUser(userSignInParams),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.authenticationErrorOccurred,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if an invalid email format is provided during sign-in',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: userSignInParams.email,
              password: userSignInParams.password,
            ),
          ).thenThrow(
            FirebaseAuthException(
              code: 'invalid-email',
              message: AppErrorMessages.invalidEmail,
            ),
          );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.signInUser(userSignInParams),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.invalidEmail,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if no user is returned during sign-in',
        () async {
          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: userSignInParams.email,
              password: userSignInParams.password,
            ),
          ).thenThrow(
            FirebaseAuthException(
              code: 'user-not-found',
              message: AppErrorMessages.userNotFound,
            ),
          );

          await expectLater(
            () => authRemoteDataSource.signInUser(userSignInParams),
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
        'should throw AuthException if an incorrect password is provided during sign-in',
        () async {
          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: userSignInParams.email,
              password: userSignInParams.password,
            ),
          ).thenThrow(
            FirebaseAuthException(
              code: 'wrong-password',
              message: AppErrorMessages.wrongPassword,
            ),
          );

          await expectLater(
            () => authRemoteDataSource.signInUser(userSignInParams),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.wrongPassword,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if invalid credentials are provided during sign-in',
        () async {
          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: userSignInParams.email,
              password: userSignInParams.password,
            ),
          ).thenThrow(
            FirebaseAuthException(
              code: 'invalid-credential',
              message: AppErrorMessages.invalidCredential,
            ),
          );

          await expectLater(
            () => authRemoteDataSource.signInUser(userSignInParams),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.invalidCredential,
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException when a database operation fails during sign-in',
        () async {
          // Arrange
          final mockUser = MockUser();
          final mockUserCredential = MockUserCredential();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockUserCredential.user).thenReturn(mockUser);

          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: userSignInParams.email,
              password: userSignInParams.password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          when(mockFirebaseMessaging.getToken())
              .thenAnswer((_) async => userUserModel.deviceToken);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId);

          whenCalling(Invocation.method(#update, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Sign-in failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.signInUser(userSignInParams),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Sign-in failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'signUpUser',
    () {
      test(
        'should return a Success Status and creates user and cart documents after sign-up',
        () async {
          // Arrange
          final mockUser = MockUser();
          final mockUserCredential = MockUserCredential();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockUserCredential.user).thenReturn(mockUser);

          when(
            mockFirebaseAuth.createUserWithEmailAndPassword(
              email: userSignUpParams.email,
              password: userSignUpParams.password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          when(mockFirebaseMessaging.getToken())
              .thenAnswer((_) async => userUserModel.deviceToken);

          // Act
          final result =
              await authRemoteDataSource.signUpUser(userSignUpParams);

          // Assert
          expect(result, ResponseTypes.success.response);

          final userSnap = await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .get();

          expect(userSnap.get('deviceToken'), userUserModel.deviceToken);
          expect(userSnap.get('email'), userUserModel.email);

          final cartSnap = await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .get();

          expect(cartSnap.exists, true);
          expect(cartSnap.get('ids'), []);

          verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: userSignUpParams.email,
            password: userSignUpParams.password,
          )).called(1);

          verify(mockFirebaseMessaging.getToken()).called(1);
        },
      );

      test(
        'should throw AuthException if a weak password is provided during sign-up',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.createUserWithEmailAndPassword(
              email: userSignUpParams.email,
              password: userSignUpParams.password,
            ),
          ).thenThrow(
            FirebaseAuthException(
              code: 'weak-password',
              message: AppErrorMessages.weekPassword,
            ),
          );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.signUpUser(userSignUpParams),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.weekPassword,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if the email is already in use during sign-up',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.createUserWithEmailAndPassword(
              email: userSignUpParams.email,
              password: userSignUpParams.password,
            ),
          ).thenThrow(
            FirebaseAuthException(
              code: 'email-already-in-use',
              message: AppErrorMessages.emailAlreadyUsed,
            ),
          );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.signUpUser(userSignUpParams),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.emailAlreadyUsed,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if an invalid email is provided during sign-up',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.createUserWithEmailAndPassword(
              email: userSignUpParams.email,
              password: userSignUpParams.password,
            ),
          ).thenThrow(
            FirebaseAuthException(
              code: 'invalid-email',
              message: AppErrorMessages.invalidEmail,
            ),
          );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.signUpUser(userSignUpParams),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.invalidEmail,
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException when a database operation fails during sign-up',
        () async {
          // Arrange
          final mockUser = MockUser();
          final mockUserCredential = MockUserCredential();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockUserCredential.user).thenReturn(mockUser);

          when(
            mockFirebaseAuth.createUserWithEmailAndPassword(
              email: userSignUpParams.email,
              password: userSignUpParams.password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          when(mockFirebaseMessaging.getToken())
              .thenAnswer((_) async => userUserModel.deviceToken);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId);

          whenCalling(Invocation.method(#set, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Sign-up failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.signUpUser(userSignUpParams),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Sign-up failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'sendEmailVerification',
    () {
      test(
        'should return a Success Status after sending email verification',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          when(mockUser.reload()).thenAnswer((_) async {});
          when(mockUser.sendEmailVerification()).thenAnswer((_) async {});

          // Act
          final result = await authRemoteDataSource.sendEmailVerification();

          // Assert
          expect(result, ResponseTypes.success.response);

          verify(mockUser.reload()).called(1);
          verify(mockUser.sendEmailVerification()).called(1);
        },
      );

      test(
        'should throw AuthException when currentUser is null during email verification sending',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          final result = await authRemoteDataSource.sendEmailVerification();

          // Assert
          expect(result, ResponseTypes.failure.response);
        },
      );

      test(
        'should throw AuthException if an error occurs during email verification sending',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          when(mockUser.reload()).thenAnswer((_) async {});

          when(
            mockUser.sendEmailVerification(),
          ).thenThrow(
            FirebaseAuthException(
              code: 'unknown',
              message: AppErrorMessages.authenticationErrorOccurred,
            ),
          );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.sendEmailVerification(),
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
    },
  );

  group(
    'getAuthUser',
    () {
      late StreamController<User?> controller;
      late MockUser mockUser;

      setUp(() {
        controller = StreamController<User?>();
        mockUser = MockUser();

        when(mockUser.uid).thenReturn(userUserId);
        when(mockFirebaseAuth.authStateChanges())
            .thenAnswer((_) => controller.stream);
      });

      tearDown(
        () async {
          await controller.close();
        },
      );

      test(
        'should emit a User when listening to user stream',
        () async {
          // Arrange
          final emittedUsers = <User?>[];
          final subscription =
              authRemoteDataSource.user.listen(emittedUsers.add);

          // Act
          controller.add(mockUser);

          // Wait for the stream to process
          await Future.delayed(Duration.zero);

          // Assert
          expect(emittedUsers, [mockUser]);

          await subscription.cancel();
        },
      );

      test(
        'should emit Null when listening to user stream (signed out)',
        () async {
          // Arrange
          final emittedUsers = <User?>[];
          final subscription =
              authRemoteDataSource.user.listen(emittedUsers.add);

          // Act
          controller.add(null);

          // Wait for the stream to process
          await Future.delayed(Duration.zero);

          // Assert
          expect(emittedUsers, [null]);

          await subscription.cancel();
        },
      );
    },
  );

  group(
    'signOutUser',
    () {
      test(
        'should return a Success Status after sign-out',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

          // Act
          final result = await authRemoteDataSource.signOutUser();

          // Assert
          expect(result, ResponseTypes.success.response);

          verify(mockFirebaseAuth.signOut()).called(1);
        },
      );

      test(
        'should throw AuthException when userCredential.user is null during sign-out',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          final result = await authRemoteDataSource.signOutUser();

          // Assert
          expect(result, ResponseTypes.failure.response);
        },
      );

      test(
        'should throw AuthException if an error occurs during sign-out',
        () async {
          // Arrange
          final mockUser = MockUser();
          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          when(
            mockFirebaseAuth.signOut(),
          ).thenThrow(
            FirebaseAuthException(
              code: 'unknown',
              message: AppErrorMessages.authenticationErrorOccurred,
            ),
          );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.signOutUser(),
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
    },
  );

  group(
    'forgotPassword',
    () {
      test(
        'should return a Success Status after sending forgot password email',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.sendPasswordResetEmail(email: userUserEmail),
          ).thenAnswer((_) async {});

          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          // Act
          final result =
              await authRemoteDataSource.forgotPassword(userUserEmail);

          // Assert
          expect(result, ResponseTypes.success.response);

          verify(mockFirebaseAuth.sendPasswordResetEmail(email: userUserEmail))
              .called(1);
        },
      );

      test(
        'should return Failure Status when the email does not exist in Firestore during forgot password email sending',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.sendPasswordResetEmail(email: userUserEmail),
          ).thenAnswer((_) async {});

          // Act
          final result =
              await authRemoteDataSource.forgotPassword(userUserEmail);

          // Assert
          expect(result, ResponseTypes.failure.response);
        },
      );

      test(
        'should throw AuthException if an error occurs during forgot password email sending',
        () async {
          // Arrange
          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          when(
            mockFirebaseAuth.sendPasswordResetEmail(email: userUserEmail),
          ).thenThrow(
            FirebaseAuthException(
              code: 'unknown',
              message: AppErrorMessages.authenticationErrorOccurred,
            ),
          );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.forgotPassword(userUserEmail),
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
        'should throw DBException when a database operation fails during forgot password email sending',
        () async {
          // Arrange
          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Forgot Password failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => authRemoteDataSource.forgotPassword(userUserEmail),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Forgot Password failed',
              ),
            ),
          );
        },
      );
    },
  );
}

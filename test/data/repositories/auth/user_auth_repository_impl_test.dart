import 'dart:async';

import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/auth/user_auth_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/auth/user_auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'user_auth_repository_impl_test.mocks.dart';

@GenerateMocks([UserAuthRemoteDataSource, User])
void main() {
  late UserAuthRepositoryImpl userAuthRepositoryImpl;
  late MockUser mockFirebaseUser;
  late MockUserAuthRemoteDataSource mockUserAuthRemoteDataSource;

  setUp(() {
    mockUserAuthRemoteDataSource = MockUserAuthRemoteDataSource();
    mockFirebaseUser = MockUser();
    userAuthRepositoryImpl = UserAuthRepositoryImpl(
        userAuthRemoteDataSource: mockUserAuthRemoteDataSource);
  });

  group(
    'signInUser',
    () {
      test(
        'should return a User Id when the sign-in process is successful',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.signInUser(signInParams))
              .thenAnswer((_) async => userId);

          // Act
          final result = await userAuthRepositoryImpl.signInUser(signInParams);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, userId),
          );
        },
      );

      test(
        'should return a Failure when the sign-in process fails',
        () async {
          // Arrange
          final authException = AuthException(
            errorMessage: 'Sign-in failed',
          );
          when(mockUserAuthRemoteDataSource.signInUser(signInParams))
              .thenThrow(authException);

          // Act
          final failure = FirebaseFailure(
            errorMessage: 'Sign-in failed',
          );
          final result = await userAuthRepositoryImpl.signInUser(signInParams);

          // Assert
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'signUpUser',
    () {
      test(
        'should return a Success Status when the sign-up process is successful',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.signUpUser(signUpParams))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await userAuthRepositoryImpl.signUpUser(signUpParams);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the sign-up process fails',
        () async {
          // Arrange
          final authException = AuthException(
            errorMessage: 'Sign-up failed',
          );
          when(mockUserAuthRemoteDataSource.signUpUser(signUpParams))
              .thenThrow(authException);

          // Act
          final failure = FirebaseFailure(
            errorMessage: 'Sign-up failed',
          );
          final result = await userAuthRepositoryImpl.signUpUser(signUpParams);

          // Assert
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'sendEmailVerification',
    () {
      test(
        'should return a Success Status when the email verification sent process is successful',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.sendEmailVerification())
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await userAuthRepositoryImpl.sendEmailVerification();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure Status when there is no current user during the email verification sent process',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.sendEmailVerification())
              .thenAnswer((_) async => ResponseTypes.failure.response);

          // Act
          final result = await userAuthRepositoryImpl.sendEmailVerification();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.failure.response),
          );
        },
      );

      test(
        'should return a Failure when the email verification sent process fails',
        () async {
          // Arrange
          final authException = AuthException(
            errorMessage: 'Email verification sent failed',
          );
          when(mockUserAuthRemoteDataSource.sendEmailVerification())
              .thenThrow(authException);

          // Act
          final failure = FirebaseFailure(
            errorMessage: 'Email verification sent failed',
          );
          final result = await userAuthRepositoryImpl.sendEmailVerification();

          // Assert
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'checkEmailVerification',
    () {
      test(
        'should return a True when the email is verified',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.checkEmailVerification())
              .thenAnswer((_) async => true);

          // Act
          final result = await userAuthRepositoryImpl.checkEmailVerification();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, true),
          );
        },
      );

      test(
        'should return a False when the email is not verified',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.checkEmailVerification())
              .thenAnswer((_) async => false);

          // Act
          final result = await userAuthRepositoryImpl.checkEmailVerification();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, false),
          );
        },
      );

      test(
        'should return a False when there is no current user during the email verification process',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.checkEmailVerification())
              .thenAnswer((_) async => false);

          // Act
          final result = await userAuthRepositoryImpl.checkEmailVerification();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, false),
          );
        },
      );

      test(
        'should return a Failure when the check email verification process fails',
        () async {
          // Arrange
          final authException = AuthException(
            errorMessage: 'Check email verification failed',
          );
          when(mockUserAuthRemoteDataSource.checkEmailVerification())
              .thenThrow(authException);

          // Act
          final failure = FirebaseFailure(
            errorMessage: 'Check email verification failed',
          );
          final result = await userAuthRepositoryImpl.checkEmailVerification();

          // Assert
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAuthUser',
    () {
      test(
        'should stream the current Firebase user',
        () async {
          // Arrange
          final userStreamController = StreamController<User?>();
          when(mockUserAuthRemoteDataSource.user)
              .thenAnswer((_) => userStreamController.stream);

          // Act
          final resultStream = userAuthRepositoryImpl.user;

          // Assert
          expectLater(
            resultStream,
            emitsInOrder([
              mockFirebaseUser,
              emitsDone, // when the stream closes
            ]),
          );

          // emit values into the stream
          userStreamController.add(mockFirebaseUser);
          await userStreamController.close();

          verify(mockUserAuthRemoteDataSource.user).called(1);
          verifyNoMoreInteractions(mockUserAuthRemoteDataSource);
        },
      );

      test(
        'should stream null when there is no authenticated Firebase user',
        () async {
          // Arrange
          final userStreamController = StreamController<User?>();
          when(mockUserAuthRemoteDataSource.user)
              .thenAnswer((_) => userStreamController.stream);

          // Act
          final resultStream = userAuthRepositoryImpl.user;

          // Assert
          expectLater(
            resultStream,
            emitsInOrder([
              null,
              emitsDone,
            ]),
          );

          userStreamController.add(null);
          await userStreamController.close();

          verify(mockUserAuthRemoteDataSource.user).called(1);
          verifyNoMoreInteractions(mockUserAuthRemoteDataSource);
        },
      );
    },
  );

  group(
    'signOutUser',
    () {
      test(
        'should return a Success Status when the sign-out process is successful',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.signOutUser())
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await userAuthRepositoryImpl.signOutUser();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure Status when the currentUser is null',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.signOutUser())
              .thenAnswer((_) async => ResponseTypes.failure.response);

          // Act
          final result = await userAuthRepositoryImpl.signOutUser();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.failure.response),
          );
        },
      );

      test(
        'should return a Failure when the sign-out process fails',
        () async {
          // Arrange

          final authException = AuthException(
            errorMessage: 'Sign-out failed',
          );
          when(mockUserAuthRemoteDataSource.signOutUser())
              .thenThrow(authException);

          // Act
          final result = await userAuthRepositoryImpl.signOutUser();

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Sign-out failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'forgotPassword',
    () {
      test(
        'should return a Success Status when the forgot password process is successful',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.forgotPassword(forgotPwEmail))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await userAuthRepositoryImpl.forgotPassword(forgotPwEmail);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the email is not stored in firestore',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.forgotPassword(forgotPwEmail))
              .thenAnswer((_) async => ResponseTypes.failure.response);

          // Act
          final result =
              await userAuthRepositoryImpl.forgotPassword(forgotPwEmail);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.failure.response),
          );
        },
      );

      test(
        'should return a Failure when the forgot password process fails',
        () async {
          // Arrange
          final authException = AuthException(
            errorMessage: 'forgot password failed',
          );
          when(mockUserAuthRemoteDataSource.forgotPassword(forgotPwEmail))
              .thenThrow(authException);

          // Act
          final result =
              await userAuthRepositoryImpl.forgotPassword(forgotPwEmail);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'forgot password failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'refreshUser',
    () {
      test(
        'should return a Firebase user when the refresh user process is successful',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.refreshUser(mockFirebaseUser))
              .thenAnswer((_) async => mockFirebaseUser);

          // Act
          final result =
              await userAuthRepositoryImpl.refreshUser(mockFirebaseUser);

          // Assert
          expect(
            result,
            mockFirebaseUser,
          );
        },
      );

      test(
        'should return a Null value when the refresh user process is fails',
        () async {
          // Arrange
          when(mockUserAuthRemoteDataSource.refreshUser(mockFirebaseUser))
              .thenAnswer((_) async => null);

          // Act
          final result =
              await userAuthRepositoryImpl.refreshUser(mockFirebaseUser);

          // Assert
          expect(
            result,
            null,
          );
        },
      );
    },
  );
}

import 'dart:async';

import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/get_auth_user_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/send_email_verification_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_in_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_out_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_up_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_user_type_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/auth_values.dart';
import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  GetAuthUserUseCase,
  GetUserTypeUseCase,
  UserSignOutUseCase,
  UserSignUpUseCase,
  SendEmailVerificationUseCase,
  UserSignInUseCase,
  ForgotPasswordUseCase,
  User,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthBloc authBloc;
  late MockUser mockUser;
  late MockGetAuthUserUseCase mockGetAuthUserUseCase;
  late MockGetUserTypeUseCase mockGetUserTypeUseCase;
  late MockUserSignOutUseCase mockUserSignOutUseCase;
  late MockUserSignUpUseCase mockUserSignUpUseCase;
  late MockSendEmailVerificationUseCase mockSendEmailVerificationUseCase;
  late MockUserSignInUseCase mockUserSignInUseCase;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;
  late StreamController<User?> userStreamController;

  setUp(() {
    mockUser = MockUser();
    mockGetAuthUserUseCase = MockGetAuthUserUseCase();
    mockGetUserTypeUseCase = MockGetUserTypeUseCase();
    mockUserSignOutUseCase = MockUserSignOutUseCase();
    mockUserSignUpUseCase = MockUserSignUpUseCase();
    mockSendEmailVerificationUseCase = MockSendEmailVerificationUseCase();
    mockUserSignInUseCase = MockUserSignInUseCase();
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    userStreamController = StreamController<User?>();

    when(mockGetAuthUserUseCase.user)
        .thenAnswer((_) => userStreamController.stream);

    authBloc = AuthBloc(
      mockGetAuthUserUseCase,
      mockGetUserTypeUseCase,
      mockUserSignOutUseCase,
      mockUserSignUpUseCase,
      mockSendEmailVerificationUseCase,
      mockUserSignInUseCase,
      mockForgotPasswordUseCase,
    );
  });

  tearDown(() {
    userStreamController.close();
    authBloc.close();
  });

  blocTest<AuthBloc, AuthState>(
    'emits [success, user, userType] when CheckUserAuthEvent is added and use case return user type',
    build: () {
      when(mockUser.uid).thenReturn(userUserId);

      when(mockGetUserTypeUseCase.call(userUserId))
          .thenAnswer((_) async => Right(userUserType));
      return authBloc;
    },
    act: (bloc) => bloc.add(CheckUserAuthEvent(user: mockUser)),
    expect: () => [
      AuthState().copyWith(
        status: BlocStatus.success,
        user: () => mockUser,
        userType: userUserType,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [error, authMessage] when CheckUserAuthEvent is added and use case return a failure',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get user type by id failed',
      );

      when(mockUser.uid).thenReturn(userUserType);

      when(mockGetUserTypeUseCase.call(userUserType))
          .thenAnswer((_) async => Left(failure));
      return authBloc;
    },
    act: (bloc) => bloc.add(CheckUserAuthEvent(user: mockUser)),
    expect: () => [
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: 'Get user type by id failed',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, success] when SignUpButtonClickedEvent is added and use cases return success',
    build: () {
      when(mockUserSignUpUseCase.call(userSignUpParams))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SignUpButtonClickedEvent(signUpParams: userSignUpParams)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(status: BlocStatus.success),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, error, authMessage] when SignUpButtonClickedEvent is added and use case return a failure',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'User SignUp failed',
      );
      when(mockUserSignUpUseCase.call(userSignUpParams))
          .thenAnswer((_) async => Left(failure));

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SignUpButtonClickedEvent(signUpParams: userSignUpParams)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: 'User SignUp failed',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, success] when SendEmailButtonClickedEvent is added and use cases return a Success Status',
    build: () {
      when(mockSendEmailVerificationUseCase.call(any))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return authBloc;
    },
    act: (bloc) => bloc.add(SendEmailButtonClickedEvent()),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(status: BlocStatus.success),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, error, authMessage] when SendEmailButtonClickedEvent is added and current user is null then return a Failure Status',
    build: () {
      when(mockSendEmailVerificationUseCase.call(any))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      return authBloc;
    },
    act: (bloc) => bloc.add(SendEmailButtonClickedEvent()),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: AppErrorMessages.failedToSendEmailVerification,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, error, authMessage] when SendEmailButtonClickedEvent is added and use cases return a failure',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Email send failed',
      );

      when(mockSendEmailVerificationUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return authBloc;
    },
    act: (bloc) => bloc.add(SendEmailButtonClickedEvent()),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: 'Email send failed',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, user, success, userType] when SignInButtonClickedEvent is added and both user sign-in and getUserType use cases return success',
    build: () {
      when(mockUserSignInUseCase.call(userSignInParams))
          .thenAnswer((_) async => Right(mockUser));

      when(mockUser.emailVerified).thenReturn(true);
      when(mockUser.uid).thenReturn(userUserId);

      when(mockGetUserTypeUseCase.call(userUserId))
          .thenAnswer((_) async => Right(userUserType));

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SignInButtonClickedEvent(signInParams: userSignInParams)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(status: BlocStatus.loading, user: () => mockUser),
      AuthState().copyWith(
        status: BlocStatus.success,
        user: () => mockUser,
        userType: userUserType,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, user, error, authMessage] when SignInButtonClickedEvent is added and user sign-in use case succeeds but getUserType use case return a failure',
    build: () {
      when(mockUserSignInUseCase.call(userSignInParams))
          .thenAnswer((_) async => Right(mockUser));

      when(mockUser.emailVerified).thenReturn(true);
      when(mockUser.uid).thenReturn(userUserId);

      final failure = FirebaseFailure(
        errorMessage: 'Get user type failed',
      );

      when(mockGetUserTypeUseCase.call(userUserId))
          .thenAnswer((_) async => Left(failure));

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SignInButtonClickedEvent(signInParams: userSignInParams)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(status: BlocStatus.loading, user: () => mockUser),
      AuthState().copyWith(
        status: BlocStatus.error,
        user: () => mockUser,
        authMessage: 'Get user type failed',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, user, error, authMessage] when SignInButtonClickedEvent is added and user sign-in use case succeeds but email is not verified',
    build: () {
      when(mockUserSignInUseCase.call(userSignInParams))
          .thenAnswer((_) async => Right(mockUser));

      when(mockUser.emailVerified).thenReturn(false);

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SignInButtonClickedEvent(signInParams: userSignInParams)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(status: BlocStatus.loading, user: () => mockUser),
      AuthState().copyWith(
        status: BlocStatus.error,
        user: () => mockUser,
        authMessage: AppErrorMessages.emailNotVerifiedYet,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, error, authMessage] when SignInButtonClickedEvent is added and user sign-in use case returns null',
    build: () {
      when(mockUserSignInUseCase.call(userSignInParams))
          .thenAnswer((_) async => Right(null));

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SignInButtonClickedEvent(signInParams: userSignInParams)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: AppErrorMessages.unauthorizedAccess,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, error, authMessage] when SignInButtonClickedEvent is added and user sign-in use case return a failure',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'User SignIn failed',
      );
      when(mockUserSignInUseCase.call(userSignInParams))
          .thenAnswer((_) async => Left(failure));

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SignInButtonClickedEvent(signInParams: userSignInParams)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: 'User SignIn failed',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, success] when SignOutEvent is added and use case return Success Status',
    build: () {
      when(mockUserSignOutUseCase.call(any))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));
      return authBloc;
    },
    act: (bloc) => bloc.add(SignOutEvent()),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(status: BlocStatus.success),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, error] when SignOutEvent is added and current user is null then return a Failure Status',
    build: () {
      when(mockUserSignOutUseCase.call(any))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));
      return authBloc;
    },
    act: (bloc) => bloc.add(SignOutEvent()),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: AppErrorMessages.unauthorizedAccess,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, error] when SignOutEvent is added and use case return a failure',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'User sign out failed',
      );
      when(mockUserSignOutUseCase.call(any))
          .thenAnswer((_) async => Left(failure));
      return authBloc;
    },
    act: (bloc) => bloc.add(SignOutEvent()),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: 'User sign out failed',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, success] when SendResetLinkButtonClickedEvent is added and use case return success',
    build: () {
      when(mockForgotPasswordUseCase.call(userUserEmail))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SendResetLinkButtonClickedEvent(email: userUserEmail)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(status: BlocStatus.success),
    ],
  );
  blocTest<AuthBloc, AuthState>(
    'emits [loading, error] when SendResetLinkButtonClickedEvent is added and use case return Failure status',
    build: () {
      when(mockForgotPasswordUseCase.call(userUserEmail))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SendResetLinkButtonClickedEvent(email: userUserEmail)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: AppErrorMessages.invalidForgotEmail,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, error] when SendResetLinkButtonClickedEvent and use case return a failure',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Password reset email send failed',
      );
      when(mockForgotPasswordUseCase.call(userUserEmail))
          .thenAnswer((_) async => Left(failure));

      return authBloc;
    },
    act: (bloc) =>
        bloc.add(SendResetLinkButtonClickedEvent(email: userUserEmail)),
    expect: () => [
      AuthState().copyWith(status: BlocStatus.loading),
      AuthState().copyWith(
        status: BlocStatus.error,
        authMessage: 'Password reset email send failed',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [user, status, authMessage, userType] when SetAuthStatusToDefault is added',
    build: () => authBloc,
    act: (bloc) => bloc.add(SetAuthStatusToDefault()),
    expect: () => [
      AuthState().copyWith(
        status: BlocStatus.initial,
        user: () => null,
        userType: '',
        authMessage: '',
      )
    ],
  );
}

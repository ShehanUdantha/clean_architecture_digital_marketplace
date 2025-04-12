import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/domain/usecases/auth/check_email_verification_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/sign_in_params.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_in_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_user_type_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'sign_in_bloc_test.mocks.dart';

@GenerateMocks([
  UserSignInUseCase,
  CheckEmailVerificationUseCase,
  GetUserTypeUseCase,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SignInBloc signInBloc;
  late MockUserSignInUseCase mockUserSignInUseCase;
  late MockCheckEmailVerificationUseCase mockCheckEmailVerificationUseCase;
  late MockGetUserTypeUseCase mockGetUserTypeUseCase;

  setUp(() {
    mockUserSignInUseCase = MockUserSignInUseCase();
    mockCheckEmailVerificationUseCase = MockCheckEmailVerificationUseCase();
    mockGetUserTypeUseCase = MockGetUserTypeUseCase();
    signInBloc = SignInBloc(
      mockUserSignInUseCase,
      mockCheckEmailVerificationUseCase,
      mockGetUserTypeUseCase,
    );
  });

  tearDown(() {
    signInBloc.close();
  });

  blocTest<SignInBloc, SignInState>(
    'emits [loading, userId, success, isVerify, userType] when SignInButtonClickedEvent is added and all use cases return success',
    build: () {
      when(mockUserSignInUseCase.call(signInParams))
          .thenAnswer((_) async => Right(userId));

      when(mockCheckEmailVerificationUseCase.call(any))
          .thenAnswer((_) async => Right(true));

      when(mockGetUserTypeUseCase.call(userId))
          .thenAnswer((_) async => Right(userType));

      return signInBloc;
    },
    act: (bloc) =>
        bloc.add(SignInButtonClickedEvent(signInParams: signInParams)),
    expect: () => [
      SignInState().copyWith(status: BlocStatus.loading),
      SignInState().copyWith(status: BlocStatus.loading, userId: userId),
      SignInState()
          .copyWith(status: BlocStatus.success, isVerify: true, userId: userId),
      SignInState().copyWith(
        status: BlocStatus.success,
        isVerify: true,
        userId: userId,
        userType: userType,
      ),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'emits [loading, userId, false] when SignInButtonClickedEvent is added and email verification check returns false',
    build: () {
      when(mockUserSignInUseCase.call(signInParams))
          .thenAnswer((_) async => Right(userId));

      when(mockCheckEmailVerificationUseCase.call(any))
          .thenAnswer((_) async => Right(false));

      return signInBloc;
    },
    act: (bloc) =>
        bloc.add(SignInButtonClickedEvent(signInParams: signInParams)),
    expect: () => [
      SignInState().copyWith(status: BlocStatus.loading),
      SignInState().copyWith(status: BlocStatus.loading, userId: userId),
      SignInState().copyWith(
        status: BlocStatus.error,
        userId: userId,
        authMessage: AppErrorMessages.emailNotVerifiedYet,
      ),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'emits [loading, userId, error] when SignInButtonClickedEvent is added and email verification check returns failure',
    build: () {
      when(mockUserSignInUseCase.call(signInParams))
          .thenAnswer((_) async => Right(userId));

      final failure = FirebaseFailure(
        errorMessage: 'Email verification check failed',
      );

      when(mockCheckEmailVerificationUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return signInBloc;
    },
    act: (bloc) =>
        bloc.add(SignInButtonClickedEvent(signInParams: signInParams)),
    expect: () => [
      SignInState().copyWith(status: BlocStatus.loading),
      SignInState().copyWith(status: BlocStatus.loading, userId: userId),
      SignInState().copyWith(
        status: BlocStatus.error,
        userId: userId,
        authMessage: 'Email verification check failed',
      ),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'emits [loading, userId, success, isVerify, error] when SignInButtonClickedEvent is added and get user type returns failure',
    build: () {
      when(mockUserSignInUseCase.call(signInParams))
          .thenAnswer((_) async => Right(userId));

      when(mockCheckEmailVerificationUseCase.call(any))
          .thenAnswer((_) async => Right(true));

      final failure = FirebaseFailure(
        errorMessage: 'Get user type failed',
      );

      when(mockGetUserTypeUseCase.call(userId))
          .thenAnswer((_) async => Left(failure));

      return signInBloc;
    },
    act: (bloc) =>
        bloc.add(SignInButtonClickedEvent(signInParams: signInParams)),
    expect: () => [
      SignInState().copyWith(status: BlocStatus.loading),
      SignInState().copyWith(status: BlocStatus.loading, userId: userId),
      SignInState()
          .copyWith(status: BlocStatus.success, isVerify: true, userId: userId),
      SignInState().copyWith(
        status: BlocStatus.success,
        userId: userId,
        isVerify: true,
        authMessage: 'Get user type failed',
      ),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'emits updated state with signInParams, status, isVerify, userId, userType and authMessage when SetSignInStatusToDefault is added',
    build: () => signInBloc,
    act: (bloc) => bloc.add(SetSignInStatusToDefault()),
    expect: () => [
      SignInState().copyWith(
        signInParams: const SignInParams(
          email: '',
          password: '',
        ),
        status: BlocStatus.initial,
        authMessage: '',
        isVerify: false,
        userId: '',
        userType: '',
      ),
    ],
  );
}

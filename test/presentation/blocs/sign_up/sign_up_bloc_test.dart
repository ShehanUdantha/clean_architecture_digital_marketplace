import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/auth/send_email_verification_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/sign_up_params.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_up_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/sign_up/sign_up_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/auth_values.dart';
import 'sign_up_bloc_test.mocks.dart';

@GenerateMocks([
  UserSignUpUseCase,
  SendEmailVerificationUseCase,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SignUpBloc signUpBloc;
  late MockUserSignUpUseCase mockUserSignUpUseCase;
  late MockSendEmailVerificationUseCase mockSendEmailVerificationUseCase;

  setUp(() {
    mockUserSignUpUseCase = MockUserSignUpUseCase();
    mockSendEmailVerificationUseCase = MockSendEmailVerificationUseCase();
    signUpBloc = SignUpBloc(
      mockUserSignUpUseCase,
      mockSendEmailVerificationUseCase,
    );
  });

  tearDown(() {
    signUpBloc.close();
  });

  blocTest<SignUpBloc, SignUpState>(
    'emits [loading, success, success] when SignUpButtonClickedEvent is added and both use cases return success',
    build: () {
      when(mockUserSignUpUseCase.call(userSignUpParams))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      when(mockSendEmailVerificationUseCase.call(any))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return signUpBloc;
    },
    act: (bloc) =>
        bloc.add(SignUpButtonClickedEvent(signUpParams: userSignUpParams)),
    expect: () => [
      SignUpState().copyWith(status: BlocStatus.loading),
      SignUpState().copyWith(status: BlocStatus.success),
    ],
  );

  blocTest<SignUpBloc, SignUpState>(
    'emits [loading, success, error, authMessage] when SignUpButtonClickedEvent is added and use cases return success and email verification send process return failure',
    build: () {
      when(mockUserSignUpUseCase.call(userSignUpParams))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      when(mockSendEmailVerificationUseCase.call(any))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      return signUpBloc;
    },
    act: (bloc) =>
        bloc.add(SignUpButtonClickedEvent(signUpParams: userSignUpParams)),
    expect: () => [
      SignUpState().copyWith(status: BlocStatus.loading),
      SignUpState().copyWith(status: BlocStatus.success),
      SignUpState().copyWith(
        status: BlocStatus.error,
        authMessage: AppErrorMessages.failedToSendEmailVerification,
      ),
    ],
  );

  blocTest<SignUpBloc, SignUpState>(
    'emits [loading, error] when SignUpButtonClickedEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'User SignUp failed',
      );
      when(mockUserSignUpUseCase.call(userSignUpParams))
          .thenAnswer((_) async => Left(failure));

      return signUpBloc;
    },
    act: (bloc) =>
        bloc.add(SignUpButtonClickedEvent(signUpParams: userSignUpParams)),
    expect: () => [
      SignUpState().copyWith(status: BlocStatus.loading),
      SignUpState().copyWith(
        status: BlocStatus.error,
        authMessage: 'User SignUp failed',
      ),
    ],
  );

  blocTest<SignUpBloc, SignUpState>(
    'emits updated state with signUpParams, status and authMessage when SetSignUpStatusToDefault is added',
    build: () => signUpBloc,
    act: (bloc) => bloc.add(SetSignUpStatusToDefault()),
    expect: () => [
      SignUpState().copyWith(
        signUpParams: const SignUpParams(
          userName: '',
          email: '',
          password: '',
        ),
        status: BlocStatus.initial,
        authMessage: '',
      ),
    ],
  );
}

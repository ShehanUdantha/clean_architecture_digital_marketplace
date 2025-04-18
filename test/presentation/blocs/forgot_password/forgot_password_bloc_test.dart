import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/auth_values.dart';
import 'forgot_password_bloc_test.mocks.dart';

@GenerateMocks([
  ForgotPasswordUseCase,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ForgotPasswordBloc forgotPasswordBloc;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;

  setUp(() {
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    forgotPasswordBloc = ForgotPasswordBloc(
      mockForgotPasswordUseCase,
    );
  });

  tearDown(() {
    forgotPasswordBloc.close();
  });

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'emits [loading, email, success] when SendResetLinkButtonClickedEvent is added and use case return success',
    build: () {
      when(mockForgotPasswordUseCase.call(userUserEmail))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return forgotPasswordBloc;
    },
    act: (bloc) =>
        bloc.add(SendResetLinkButtonClickedEvent(email: userUserEmail)),
    expect: () => [
      ForgotPasswordState().copyWith(
        status: BlocStatus.loading,
        email: userUserEmail,
      ),
      ForgotPasswordState().copyWith(
        status: BlocStatus.success,
        email: userUserEmail,
      ),
    ],
  );

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'emits [loading, email, error] when SendResetLinkButtonClickedEvent is added and use case return failure',
    build: () {
      when(mockForgotPasswordUseCase.call(userUserEmail))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      return forgotPasswordBloc;
    },
    act: (bloc) =>
        bloc.add(SendResetLinkButtonClickedEvent(email: userUserEmail)),
    expect: () => [
      ForgotPasswordState().copyWith(
        status: BlocStatus.loading,
        email: userUserEmail,
      ),
      ForgotPasswordState().copyWith(
        status: BlocStatus.error,
        email: userUserEmail,
        authMessage: AppErrorMessages.invalidForgotEmail,
      ),
    ],
  );

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'emits [loading, email, error] when SendResetLinkButtonClickedEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Password reset email send failed',
      );
      when(mockForgotPasswordUseCase.call(userUserEmail))
          .thenAnswer((_) async => Left(failure));

      return forgotPasswordBloc;
    },
    act: (bloc) =>
        bloc.add(SendResetLinkButtonClickedEvent(email: userUserEmail)),
    expect: () => [
      ForgotPasswordState().copyWith(
        status: BlocStatus.loading,
        email: userUserEmail,
      ),
      ForgotPasswordState().copyWith(
        status: BlocStatus.error,
        email: userUserEmail,
        authMessage: 'Password reset email send failed',
      ),
    ],
  );

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'emits updated state with status when SetForgotStatusToDefault is added',
    build: () => forgotPasswordBloc,
    act: (bloc) => bloc.add(SetForgotStatusToDefault()),
    expect: () => [
      ForgotPasswordState().copyWith(
        status: BlocStatus.initial,
      ),
    ],
  );
}

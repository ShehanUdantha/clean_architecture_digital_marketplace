import 'dart:async';

import '../../../domain/usecases/auth/sign_in_params.dart';
import 'package:bloc/bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/auth/check_email_verification_usecase.dart';
import '../../../domain/usecases/user/get_user_type_usecase.dart';
import '../../../domain/usecases/auth/user_sign_in_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enum.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserSignInUseCase userSignInUseCase;
  final CheckEmailVerificationUseCase checkEmailVerificationUseCase;
  final GetUserTypeUseCase getUserTypeUseCase;

  SignInBloc(
    this.userSignInUseCase,
    this.checkEmailVerificationUseCase,
    this.getUserTypeUseCase,
  ) : super(const SignInState()) {
    on<SignInButtonClickedEvent>(onSignInButtonClickedEvent);
    on<CheckEmailVerificationEvent>(onCheckEmailVerificationEvent);
    on<GetUserTypeEvent>(onGetUserTypeEvent);
    on<SetSignInStatusToDefault>(onSetSignInStatusToDefault);
  }

  FutureOr<void> onSignInButtonClickedEvent(
    SignInButtonClickedEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await userSignInUseCase.call(event.signInParams);
    result.fold(
      (l) => emit(
        state.copyWith(authMessage: l.errorMessage, status: BlocStatus.error),
      ),
      (r) {
        emit(
          state.copyWith(userId: r),
        );
        add(CheckEmailVerificationEvent());
      },
    );
  }

  FutureOr<void> onCheckEmailVerificationEvent(
    CheckEmailVerificationEvent event,
    Emitter<SignInState> emit,
  ) async {
    final result = await checkEmailVerificationUseCase.call(NoParams());
    result.fold(
      (l) => emit(
        state.copyWith(authMessage: l.errorMessage, status: BlocStatus.error),
      ),
      (r) {
        if (r) {
          emit(
            state.copyWith(isVerify: r, status: BlocStatus.success),
          );
          add(GetUserTypeEvent());
        } else {
          emit(
            state.copyWith(status: BlocStatus.error),
          );
        }
      },
    );
  }

  FutureOr<void> onGetUserTypeEvent(
    GetUserTypeEvent event,
    Emitter<SignInState> emit,
  ) async {
    final result = await getUserTypeUseCase.call(state.userId);
    result.fold(
      (l) => emit(
        state.copyWith(authMessage: l.errorMessage),
      ),
      (r) => emit(
        state.copyWith(userType: r),
      ),
    );
  }

  FutureOr<void> onSetSignInStatusToDefault(
    SetSignInStatusToDefault event,
    Emitter<SignInState> emit,
  ) {
    emit(
      state.copyWith(
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
    );
  }
}

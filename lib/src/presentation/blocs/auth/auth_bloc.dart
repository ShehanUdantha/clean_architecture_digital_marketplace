import 'dart:async';

import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/send_email_verification_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/sign_in_params.dart';
import 'package:Pixelcart/src/domain/usecases/auth/sign_up_params.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_in_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_up_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extension.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/enum.dart';
import '../../../domain/usecases/auth/get_auth_user_usecase.dart';
import '../../../domain/usecases/auth/user_sign_out_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/usecases/user/get_user_type_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final GetUserTypeUseCase getUserTypeUseCase;
  final UserSignOutUseCase userSignOutUseCase;
  final UserSignUpUseCase userSignUpUseCase;
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;
  final UserSignInUseCase userSignInUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  late final StreamSubscription<User?> userSubscription;

  AuthBloc(
    this.getAuthUserUseCase,
    this.getUserTypeUseCase,
    this.userSignOutUseCase,
    this.userSignUpUseCase,
    this.sendEmailVerificationUseCase,
    this.userSignInUseCase,
    this.forgotPasswordUseCase,
  ) : super(const AuthState(status: BlocStatus.loading)) {
    on<CheckUserAuthEvent>(onCheckUserAuth);
    on<SignUpButtonClickedEvent>(onSignUpButtonClickedEvent);
    on<SendEmailButtonClickedEvent>(onSendEmailButtonClickedEvent);
    on<SignInButtonClickedEvent>(onSignInButtonClickedEvent);
    on<GetUserTypeEvent>(onGetUserTypeEvent);
    on<SignOutEvent>(onSignOutEvent);
    on<SendResetLinkButtonClickedEvent>(onSendResetLinkButtonClickedEvent);
    on<SetAuthStatusToDefault>(onSetStatusToDefault);

    userSubscription = getAuthUserUseCase.user.listen((user) {
      if (user != null) {
        add(CheckUserAuthEvent(user: user));
      } else {
        add(SetAuthStatusToDefault());
      }
    });
  }

  FutureOr<void> onCheckUserAuth(
    CheckUserAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getUserTypeUseCase.call(event.user!.uid);

    result.fold(
      (l) => emit(
        state.copyWith(
          authMessage: l.errorMessage,
          status: BlocStatus.error,
        ),
      ),
      (r) => emit(
        state.copyWith(
          user: () => event.user,
          userType: r,
          status: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onSignUpButtonClickedEvent(
    SignUpButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await userSignUpUseCase.call(event.signUpParams);

    result.fold(
      (l) => emit(
        state.copyWith(
          authMessage: l.errorMessage,
          status: BlocStatus.error,
        ),
      ),
      (r) => emit(
        state.copyWith(status: BlocStatus.success),
      ),
    );
  }

  FutureOr<void> onSendEmailButtonClickedEvent(
    SendEmailButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await sendEmailVerificationUseCase.call(NoParams());

    result.fold(
      (l) => emit(
        state.copyWith(
          authMessage: l.errorMessage,
          status: BlocStatus.error,
        ),
      ),
      (r) {
        if (r == ResponseTypes.success.response) {
          emit(
            state.copyWith(status: BlocStatus.success),
          );
        } else {
          emit(
            state.copyWith(
              authMessage: rootNavigatorKey
                      .currentContext?.loc.failedToSendEmailVerification ??
                  AppErrorMessages.failedToSendEmailVerification,
              status: BlocStatus.error,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onSignInButtonClickedEvent(
    SignInButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await userSignInUseCase.call(event.signInParams);

    result.fold(
      (l) => emit(
        state.copyWith(
          authMessage: l.errorMessage,
          status: BlocStatus.error,
        ),
      ),
      (r) {
        if (r != null) {
          emit(
            state.copyWith(user: () => r),
          );

          if (r.emailVerified) {
            add(GetUserTypeEvent(uid: r.uid));
          } else {
            emit(
              state.copyWith(
                authMessage:
                    rootNavigatorKey.currentContext?.loc.emailNotVerifiedYet ??
                        AppErrorMessages.emailNotVerifiedYet,
                status: BlocStatus.error,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              authMessage:
                  rootNavigatorKey.currentContext?.loc.unauthorizedAccess ??
                      AppErrorMessages.unauthorizedAccess,
              status: BlocStatus.error,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onGetUserTypeEvent(
    GetUserTypeEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getUserTypeUseCase.call(event.uid);

    result.fold(
      (l) => emit(
        state.copyWith(
          authMessage: l.errorMessage,
          status: BlocStatus.error,
        ),
      ),
      (r) => emit(
        state.copyWith(
          userType: r,
          status: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onSignOutEvent(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await userSignOutUseCase.call(NoParams());

    result.fold(
      (l) => emit(
        state.copyWith(
          authMessage: l.errorMessage,
          status: BlocStatus.error,
        ),
      ),
      (r) {
        if (r == ResponseTypes.success.response) {
          emit(
            state.copyWith(status: BlocStatus.success),
          );
        } else {
          emit(
            state.copyWith(
              authMessage:
                  rootNavigatorKey.currentContext?.loc.unauthorizedAccess ??
                      AppErrorMessages.unauthorizedAccess,
              status: BlocStatus.error,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onSendResetLinkButtonClickedEvent(
    SendResetLinkButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await forgotPasswordUseCase.call(event.email);

    result.fold(
      (l) => emit(
        state.copyWith(
          authMessage: l.errorMessage,
          status: BlocStatus.error,
        ),
      ),
      (r) {
        if (r == ResponseTypes.success.response) {
          emit(
            state.copyWith(status: BlocStatus.success),
          );
        } else {
          emit(
            state.copyWith(
              authMessage:
                  rootNavigatorKey.currentContext?.loc.invalidForgotEmail ??
                      AppErrorMessages.invalidForgotEmail,
              status: BlocStatus.error,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onSetStatusToDefault(
    SetAuthStatusToDefault event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        user: () => null,
        status: BlocStatus.initial,
        authMessage: '',
        userType: '',
      ),
    );
  }

  @override
  Future<void> close() {
    userSubscription.cancel();
    return super.close();
  }

  String? get currentUserId => state.user?.uid;
}

import 'dart:async';

import '../../../config/routes/router.dart';
import '../../../core/constants/error_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extension.dart';
import '../../../core/utils/enum.dart';
import '../../../domain/usecases/auth/forgot_password_usecase.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordBloc(this.forgotPasswordUseCase)
      : super(const ForgotPasswordState()) {
    on<SendResetLinkButtonClickedEvent>(onSendResetLinkButtonClickedEvent);
    on<SetForgotStatusToDefault>(onSetForgotStatusToDefault);
  }

  FutureOr<void> onSendResetLinkButtonClickedEvent(
    SendResetLinkButtonClickedEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(
      status: BlocStatus.loading,
      email: event.email,
    ));

    final result = await forgotPasswordUseCase.call(event.email);
    result.fold(
      (l) => emit(
        state.copyWith(authMessage: l.errorMessage, status: BlocStatus.error),
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

  FutureOr<void> onSetForgotStatusToDefault(
    SetForgotStatusToDefault event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        status: BlocStatus.initial,
      ),
    );
  }
}

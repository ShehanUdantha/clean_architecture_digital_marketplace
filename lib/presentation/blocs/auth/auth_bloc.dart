import 'dart:async';

import '../../../core/utils/extension.dart';
import '../../../domain/usecases/auth/refresh_user_usecase.dart';
import 'package:bloc/bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/enum.dart';
import '../../../domain/usecases/auth/get_auth_user_usecase.dart';
import '../../../domain/usecases/auth/user_sign_out_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../domain/usecases/user/get_user_type_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final GetUserTypeUseCase getUserTypeUseCase;
  final UserSignOutUseCase userSignOutUseCase;
  final RefreshUserUseCase refreshUserUseCase;

  late final StreamSubscription<User?> userSubscription;

  AuthBloc(
    this.getAuthUserUseCase,
    this.getUserTypeUseCase,
    this.userSignOutUseCase,
    this.refreshUserUseCase,
  ) : super(const LoadingState(statusValue: BlocStatus.loading)) {
    on<CheckUserAuthEvent>(onCheckUserAuth);
    on<SignOutEvent>(onSignOutEvent);
    on<RefreshUserEvent>(onRefreshUserEvent);
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
        const AuthFailureState(statusValue: BlocStatus.error),
      ),
      (r) => emit(
        AuthSuccessState(
          userValue: event.user!,
          userTypeValue: r,
          statusValue: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onSignOutEvent(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await userSignOutUseCase.call(NoParams());
    result.fold(
      (l) => emit(
        const AuthFailureState(statusValue: BlocStatus.error),
      ),
      (r) {
        if (r == ResponseTypes.success.response) {
          emit(
            const SignOutState(signOutStatusValue: BlocStatus.success),
          );
        } else {
          emit(
            const SignOutState(signOutStatusValue: BlocStatus.error),
          );
        }
      },
    );
  }

  FutureOr<void> onRefreshUserEvent(
    RefreshUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await refreshUserUseCase.refreshUserCall(state.user);
    emit(
      AuthSuccessState(
        userValue: result!,
        userTypeValue: state.userType,
        statusValue: BlocStatus.success,
      ),
    );
  }

  FutureOr<void> onSetStatusToDefault(
    SetAuthStatusToDefault event,
    Emitter<AuthState> emit,
  ) {
    emit(
      const InitialState(
        statusValue: BlocStatus.initial,
        userTypeValue: '',
        signOutStatusValue: BlocStatus.initial,
      ),
    );
  }

  @override
  Future<void> close() {
    userSubscription.cancel();
    return super.close();
  }
}

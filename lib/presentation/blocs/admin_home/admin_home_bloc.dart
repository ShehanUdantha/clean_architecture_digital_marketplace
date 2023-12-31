import 'dart:async';

import '../../../domain/usecases/user/get_user_details_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/user/user_entity.dart';

part 'admin_home_event.dart';
part 'admin_home_state.dart';

class AdminHomeBloc extends Bloc<AdminHomeEvent, AdminHomeState> {
  final GetUserDetailsUseCase getUserDetailsUseCase;

  AdminHomeBloc(this.getUserDetailsUseCase) : super(const AdminHomeState()) {
    on<GetAdminDetailsEvent>(onGetAdminDetailsEvent);
    on<SetAdminDetailsToDefault>(onSetAdminDetailsToDefault);
  }

  FutureOr<void> onGetAdminDetailsEvent(
    GetAdminDetailsEvent event,
    Emitter<AdminHomeState> emit,
  ) async {
    final result = await getUserDetailsUseCase.call(NoParams());
    result.fold(
      (l) => null,
      (r) => emit(
        state.copyWith(
          userEntity: r,
        ),
      ),
    );
  }

  FutureOr<void> onSetAdminDetailsToDefault(
    SetAdminDetailsToDefault event,
    Emitter<AdminHomeState> emit,
  ) {
    emit(
      state.copyWith(
        userEntity: const UserEntity(
          userId: '',
          userType: '',
          userName: '',
          email: '',
          password: '',
        ),
      ),
    );
  }
}

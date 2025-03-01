import 'dart:async';

import '../../../core/constants/variable_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/usecases/user/get_all_users_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/enum.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetAllUsersUseCase getAllUsersUseCase;

  UsersBloc(this.getAllUsersUseCase) : super(const UsersState()) {
    on<GetAllUsersEvent>(onGetAllUsersEvent);
    on<UserTypeSelectEvent>(onUserTypeSelectEvent);
  }

  FutureOr<void> onGetAllUsersEvent(
    GetAllUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await getAllUsersUseCase.call(state.currentUserTypeName);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfUsers: r,
          status: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onUserTypeSelectEvent(
    UserTypeSelectEvent event,
    Emitter<UsersState> emit,
  ) {
    emit(
      state.copyWith(
        currentUserType: event.value,
        currentUserTypeName: event.name,
      ),
    );
  }
}

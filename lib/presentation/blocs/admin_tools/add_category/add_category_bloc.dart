import 'dart:async';

import '../../../../core/utils/extension.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enum.dart';
import '../../../../../domain/usecases/category/add_category_usecase.dart';

part 'add_category_event.dart';
part 'add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final AddCategoryUseCase addCategoryUseCase;

  AddCategoryBloc(this.addCategoryUseCase) : super(const AddCategoryState()) {
    on<CategoryButtonClickedEvent>(onCategoryButtonClickedEvent);
    on<SetCategoryStatusToDefault>(onSetCategoryStatusToDefault);
  }

  FutureOr<void> onCategoryButtonClickedEvent(
    CategoryButtonClickedEvent event,
    Emitter<AddCategoryState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await addCategoryUseCase.call(event.category);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) {
        if (r == ResponseTypes.success.response) {
          emit(
            state.copyWith(
              message: r,
              status: BlocStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              message: r,
              status: BlocStatus.error,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onSetCategoryStatusToDefault(
    SetCategoryStatusToDefault event,
    Emitter<AddCategoryState> emit,
  ) {
    emit(
      state.copyWith(
        status: BlocStatus.initial,
        message: '',
        category: '',
      ),
    );
  }
}

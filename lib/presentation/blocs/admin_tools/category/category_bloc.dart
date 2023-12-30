import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/enum.dart';
import '../../../../domain/entities/category/category_entity.dart';
import '../../../../domain/usecases/category/delete_category_usecase.dart';
import '../../../../domain/usecases/category/get_all_categories_usecase.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryBloc(
    this.getAllCategoriesUseCase,
    this.deleteCategoryUseCase,
  ) : super(const CategoryState()) {
    on<GetAllCategoriesEvent>(onGetAllCategoriesEvent);
    on<DeleteCategoriesEvent>(onDeleteCategoriesEvent);
    on<SetDeleteStateToDefault>(onSetDeleteStateToDefault);
  }

  FutureOr<void> onGetAllCategoriesEvent(
    GetAllCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await getAllCategoriesUseCase.call(NoParams());
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfCategories: r,
          status: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onDeleteCategoriesEvent(
    DeleteCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await deleteCategoryUseCase.call(event.id);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          message: r,
          status: BlocStatus.success,
          isDeleted: true,
        ),
      ),
    );
  }

  FutureOr<void> onSetDeleteStateToDefault(
    SetDeleteStateToDefault event,
    Emitter<CategoryState> emit,
  ) {
    emit(state.copyWith(isDeleted: false));
  }
}

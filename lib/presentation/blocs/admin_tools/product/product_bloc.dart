import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../../domain/entities/product/product_entity.dart';
import '../../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../../domain/usecases/product/get_all_products_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enum.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductBloc(
    this.getAllProductsUseCase,
    this.deleteProductUseCase,
  ) : super(const ProductState()) {
    on<CategorySelectEvent>(onCategorySelectEvent);
    on<GetAllProductsEvent>(onGetAllProductsEvent);
    on<ProductDeleteEvent>(onProductDeleteEvent);
    on<SetProductDeleteStateToDefault>(onSetProductDeleteStateToDefault);
  }

  FutureOr<void> onCategorySelectEvent(
    CategorySelectEvent event,
    Emitter<ProductState> emit,
  ) {
    emit(
      state.copyWith(
        currentCategory: event.value,
        currentCategoryName: event.name,
      ),
    );
  }

  FutureOr<void> onGetAllProductsEvent(
    GetAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await getAllProductsUseCase.call(state.currentCategoryName);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfProducts: r,
          status: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onProductDeleteEvent(
    ProductDeleteEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await deleteProductUseCase.call(event.id);
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

  FutureOr<void> onSetProductDeleteStateToDefault(
    SetProductDeleteStateToDefault event,
    Emitter<ProductState> emit,
  ) {
    emit(state.copyWith(isDeleted: false));
  }
}

import 'dart:async';
import 'dart:io';

import '../../../core/utils/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product/product_entity.dart';
import '../../../domain/usecases/product/add_product_usecase.dart';
import '../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../domain/usecases/product/edit_product_usecase.dart';
import '../../../domain/usecases/product/get_all_products_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/enum.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AddProductUseCase addProductUseCase;
  final EditProductUseCase editProductUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductBloc(
    this.addProductUseCase,
    this.editProductUseCase,
    this.getAllProductsUseCase,
    this.deleteProductUseCase,
  ) : super(const ProductState()) {
    on<CategoryNameFieldChangeEvent>(onCategoryNameFieldChangeEvent);
    on<MarketingTypeFieldChangeEvent>(onMarketingTypeFieldChangeEvent);
    on<ProductUploadButtonClickedEvent>(onProductUploadButtonClickedEvent);
    on<ProductEditButtonClickedEvent>(onProductEditButtonClickedEvent);
    on<SetProductAddAndEditStatusToDefault>(
        onSetProductAddAndEditStatusToDefault);

    on<CategorySelectEvent>(onCategorySelectEvent);
    on<GetAllProductsEvent>(onGetAllProductsEvent);
    on<ProductDeleteEvent>(onProductDeleteEvent);
    on<SetProductDeleteStateToDefault>(onSetProductDeleteStateToDefault);
  }

  FutureOr<void> onCategoryNameFieldChangeEvent(
    CategoryNameFieldChangeEvent event,
    Emitter<ProductState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  FutureOr<void> onMarketingTypeFieldChangeEvent(
    MarketingTypeFieldChangeEvent event,
    Emitter<ProductState> emit,
  ) {
    emit(state.copyWith(marketingType: event.type));
  }

  FutureOr<void> onProductUploadButtonClickedEvent(
    ProductUploadButtonClickedEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(productAddAndEditStatus: BlocStatus.loading));

    ProductEntity productEntity = ProductEntity(
      productName: event.productName,
      price: event.productPrice,
      category: state.category,
      marketingType: state.marketingType,
      description: event.productDescription,
      coverImage: event.coverImage,
      subImages: event.subImages,
      zipFile: event.zipFile,
      likes: const [],
      status: '',
    );

    final result = await addProductUseCase.call(productEntity);
    result.fold(
      (l) => emit(
        state.copyWith(
          productAddAndEditMessage: l.errorMessage,
          productAddAndEditStatus: BlocStatus.error,
        ),
      ),
      (r) {
        if (r == ResponseTypes.success.response) {
          emit(
            state.copyWith(
              productAddAndEditMessage: r,
              productAddAndEditStatus: BlocStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              productAddAndEditMessage: r,
              productAddAndEditStatus: BlocStatus.error,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onProductEditButtonClickedEvent(
    ProductEditButtonClickedEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(productAddAndEditStatus: BlocStatus.loading));

    ProductEntity productEntity = ProductEntity(
      id: event.id,
      productName: event.productName,
      price: event.productPrice,
      category: state.category,
      marketingType: state.marketingType,
      description: event.productDescription,
      coverImage: event.coverImage,
      subImages: event.subImages,
      zipFile: event.zipFile,
      sharedSubImages: event.sharedSubImages,
      likes: event.likes,
      status: event.status,
    );

    final result = await editProductUseCase.call(productEntity);
    result.fold(
      (l) => emit(
        state.copyWith(
          productAddAndEditMessage: l.errorMessage,
          productAddAndEditStatus: BlocStatus.error,
        ),
      ),
      (r) {
        if (r == ResponseTypes.success.response) {
          emit(
            state.copyWith(
              productAddAndEditMessage: r,
              productAddAndEditStatus: BlocStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              productAddAndEditMessage: r,
              productAddAndEditStatus: BlocStatus.error,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onSetProductAddAndEditStatusToDefault(
    SetProductAddAndEditStatusToDefault event,
    Emitter<ProductState> emit,
  ) {
    emit(
      state.copyWith(
        productAddAndEditStatus: BlocStatus.initial,
        productAddAndEditMessage: '',
      ),
    );
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

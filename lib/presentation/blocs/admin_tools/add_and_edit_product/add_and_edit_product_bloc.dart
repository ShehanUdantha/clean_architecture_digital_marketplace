import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extension.dart';
import '../../../../core/utils/enum.dart';
import '../../../../domain/entities/product/product_entity.dart';
import '../../../../domain/usecases/product/add_product_usecase.dart';
import '../../../../domain/usecases/product/edit_product_usecase.dart';
import 'package:equatable/equatable.dart';

part 'add_and_edit_product_event.dart';
part 'add_and_edit_product_state.dart';

class AddAndEditProductBloc
    extends Bloc<AddAndEditProductEvent, AddAndEditProductState> {
  final AddProductUseCase addProductUseCase;
  final EditProductUseCase editProductUseCase;

  AddAndEditProductBloc(
    this.addProductUseCase,
    this.editProductUseCase,
  ) : super(const AddAndEditProductState()) {
    on<CategoryNameFieldChangeEvent>(onCategoryNameFieldChangeEvent);
    on<MarketingTypeFieldChangeEvent>(onMarketingTypeFieldChangeEvent);
    on<ProductUploadButtonClickedEvent>(onProductUploadButtonClickedEvent);
    on<SetProductStatusToDefault>(onSetProductStatusToDefault);
    on<ProductEditButtonClickedEvent>(onProductEditButtonClickedEvent);
  }

  FutureOr<void> onCategoryNameFieldChangeEvent(
    CategoryNameFieldChangeEvent event,
    Emitter<AddAndEditProductState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  FutureOr<void> onMarketingTypeFieldChangeEvent(
    MarketingTypeFieldChangeEvent event,
    Emitter<AddAndEditProductState> emit,
  ) {
    emit(state.copyWith(marketingType: event.type));
  }

  FutureOr<void> onProductUploadButtonClickedEvent(
    ProductUploadButtonClickedEvent event,
    Emitter<AddAndEditProductState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

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

  FutureOr<void> onSetProductStatusToDefault(
    SetProductStatusToDefault event,
    Emitter<AddAndEditProductState> emit,
  ) {
    emit(state.copyWith(
      status: BlocStatus.initial,
      message: '',
    ));
  }

  FutureOr<void> onProductEditButtonClickedEvent(
    ProductEditButtonClickedEvent event,
    Emitter<AddAndEditProductState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

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
}

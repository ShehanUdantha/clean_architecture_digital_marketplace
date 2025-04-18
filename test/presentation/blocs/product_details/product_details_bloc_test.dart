import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/cart/add_product_to_cart_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/get_carted_items_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/remove_product_from_cart_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/product/add_favorite_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/product/get_product_details_by_id_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/product_details/product_details_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/cart_values.dart';
import '../../../fixtures/product_values.dart';
import 'product_details_bloc_test.mocks.dart';

@GenerateMocks([
  GetProductDetailsByIdUseCase,
  AddProductToCartUseCase,
  GetCartedItemsUseCase,
  RemoveProductFromCartUseCase,
  AddFavoriteUseCase,
])
void main() {
  late ProductDetailsBloc productDetailsBloc;
  late MockGetProductDetailsByIdUseCase mockGetProductDetailsByIdUseCase;
  late MockAddProductToCartUseCase mockAddProductToCartUseCase;
  late MockGetCartedItemsUseCase mockGetCartedItemsUseCase;
  late MockRemoveProductFromCartUseCase mockRemoveProductFromCartUseCase;
  late MockAddFavoriteUseCase mockAddFavoriteUseCase;

  setUp(() {
    mockGetProductDetailsByIdUseCase = MockGetProductDetailsByIdUseCase();
    mockAddProductToCartUseCase = MockAddProductToCartUseCase();
    mockGetCartedItemsUseCase = MockGetCartedItemsUseCase();
    mockRemoveProductFromCartUseCase = MockRemoveProductFromCartUseCase();
    mockAddFavoriteUseCase = MockAddFavoriteUseCase();
    productDetailsBloc = ProductDetailsBloc(
      mockGetProductDetailsByIdUseCase,
      mockAddProductToCartUseCase,
      mockGetCartedItemsUseCase,
      mockRemoveProductFromCartUseCase,
      mockAddFavoriteUseCase,
    );
  });

  tearDown(() {
    productDetailsBloc.close();
  });

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, success, productEntity] when GetProductDetailsEvent is added and use case return productEntity',
    build: () {
      when(mockGetProductDetailsByIdUseCase.call(productId))
          .thenAnswer((_) async => Right(productIdThreeEntity));

      return productDetailsBloc;
    },
    act: (bloc) => bloc.add(GetProductDetailsEvent(id: productId)),
    expect: () => [
      ProductDetailsState().copyWith(status: BlocStatus.loading),
      ProductDetailsState().copyWith(
        status: BlocStatus.success,
        productEntity: productIdThreeEntity,
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, error, message] when GetProductDetailsEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get product details by id failed',
      );
      when(mockGetProductDetailsByIdUseCase.call(productId))
          .thenAnswer((_) async => Left(failure));

      return productDetailsBloc;
    },
    act: (bloc) => bloc.add(GetProductDetailsEvent(id: productId)),
    expect: () => [
      ProductDetailsState().copyWith(status: BlocStatus.loading),
      ProductDetailsState().copyWith(
        status: BlocStatus.error,
        message: 'Get product details by id failed',
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits updated state with currentSubImageNumber when ChangeCurrentSubImageNumberEvent is added',
    build: () => productDetailsBloc,
    act: (bloc) => bloc
        .add(ChangeCurrentSubImageNumberEvent(index: productSubImageNumber)),
    expect: () => [
      ProductDetailsState().copyWith(
        currentSubImageNumber: productSubImageNumber,
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, success, cartedMessage] when AddProductToCartEvent is added and use case return success',
    build: () {
      when(mockAddProductToCartUseCase.call(productId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return productDetailsBloc;
    },
    act: (bloc) => bloc.add(AddProductToCartEvent(id: productId)),
    expect: () => [
      ProductDetailsState().copyWith(cartedStatus: BlocStatus.loading),
      ProductDetailsState().copyWith(
        cartedStatus: BlocStatus.success,
        cartedMessage: CURDTypes.add.curd,
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, error, cartedMessage] when AddProductToCartEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Add product to cart failed',
      );
      when(mockAddProductToCartUseCase.call(productId))
          .thenAnswer((_) async => Left(failure));

      return productDetailsBloc;
    },
    act: (bloc) => bloc.add(AddProductToCartEvent(id: productId)),
    expect: () => [
      ProductDetailsState().copyWith(cartedStatus: BlocStatus.loading),
      ProductDetailsState().copyWith(
        cartedStatus: BlocStatus.error,
        cartedMessage: 'Add product to cart failed',
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, success, cartedMessage] when GetCartedItemsEvent is added and use case return success',
    build: () {
      when(mockGetCartedItemsUseCase.call(any))
          .thenAnswer((_) async => Right(cartedProductsIds));

      return productDetailsBloc;
    },
    act: (bloc) => bloc.add(GetCartedItemsEvent()),
    expect: () => [
      ProductDetailsState().copyWith(
        cartedItems: cartedProductsIds,
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits no state when GetCartedItemsEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Add product to cart failed',
      );
      when(mockGetCartedItemsUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return productDetailsBloc;
    },
    act: (bloc) => bloc.add(GetCartedItemsEvent()),
    expect: () => [],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, success, cartedMessage] when RemoveProductFromCartEvent is added and use case return success',
    build: () {
      when(mockRemoveProductFromCartUseCase.call(productId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return productDetailsBloc;
    },
    act: (bloc) => bloc.add(RemoveProductFromCartEvent(id: productId)),
    expect: () => [
      ProductDetailsState().copyWith(cartedStatus: BlocStatus.loading),
      ProductDetailsState().copyWith(
        cartedStatus: BlocStatus.success,
        cartedMessage: CURDTypes.remove.curd,
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, error, cartedMessage] when RemoveProductFromCartEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Remove product to cart failed',
      );
      when(mockRemoveProductFromCartUseCase.call(productId))
          .thenAnswer((_) async => Left(failure));

      return productDetailsBloc;
    },
    act: (bloc) => bloc.add(RemoveProductFromCartEvent(id: productId)),
    expect: () => [
      ProductDetailsState().copyWith(cartedStatus: BlocStatus.loading),
      ProductDetailsState().copyWith(
        cartedStatus: BlocStatus.error,
        cartedMessage: 'Remove product to cart failed',
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits updated state with cartedStatus and cartedMessage when SetProductDetailsToDefaultEvent is added',
    build: () => productDetailsBloc,
    act: (bloc) => bloc.add(SetProductDetailsToDefaultEvent()),
    expect: () => [
      ProductDetailsState().copyWith(
        cartedStatus: BlocStatus.initial,
        cartedMessage: '',
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, success, favorite success] when GetProductDetailsEvent and AddFavoriteToProductEvent are added sequentially and use cases return success',
    build: () {
      when(mockGetProductDetailsByIdUseCase.call(productId))
          .thenAnswer((_) async => Right(productIdThreeEntity));

      when(mockAddFavoriteUseCase.call(any))
          .thenAnswer((_) async => Right(productIdThreeNewEntity));

      return productDetailsBloc;
    },
    act: (bloc) async {
      bloc.add(GetProductDetailsEvent(id: productId));
      await Future.delayed(Duration.zero);
      bloc.add(AddFavoriteToProductEvent());
    },
    expect: () => [
      ProductDetailsState().copyWith(status: BlocStatus.loading),
      ProductDetailsState().copyWith(
        status: BlocStatus.success,
        productEntity: productIdThreeEntity,
      ),
      ProductDetailsState().copyWith(
        status: BlocStatus.success,
        productEntity: productIdThreeNewEntity,
        favoriteStatus: BlocStatus.success,
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, success, favorite error, favoriteMessage] when AddFavoriteToProductEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Add favorite to product failed',
      );

      when(mockGetProductDetailsByIdUseCase.call(productId))
          .thenAnswer((_) async => Right(productIdThreeEntity));

      when(mockAddFavoriteUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return productDetailsBloc;
    },
    act: (bloc) async {
      bloc.add(GetProductDetailsEvent(id: productId));
      await Future.delayed(Duration.zero);
      bloc.add(AddFavoriteToProductEvent());
    },
    expect: () => [
      ProductDetailsState().copyWith(status: BlocStatus.loading),
      ProductDetailsState().copyWith(
        status: BlocStatus.success,
        productEntity: productIdThreeEntity,
      ),
      ProductDetailsState().copyWith(
        status: BlocStatus.success,
        productEntity: productIdThreeEntity,
        favoriteStatus: BlocStatus.error,
        favoriteMessage: 'Add favorite to product failed',
      ),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits updated state with favoriteStatus and favoriteMessage when SetProductFavoriteToDefaultEvent is added',
    build: () => productDetailsBloc,
    act: (bloc) => bloc.add(SetProductFavoriteToDefaultEvent()),
    expect: () => [
      ProductDetailsState().copyWith(
        favoriteMessage: '',
        favoriteStatus: BlocStatus.initial,
      ),
    ],
  );
}

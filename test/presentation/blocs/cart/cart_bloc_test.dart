import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/cart/get_all_carted_items_details_by_id_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/get_carted_items_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/set_cart_details_to_purchase_history_and_delete_cart_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/remove_product_from_cart_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/cart/cart_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/cart_values.dart';
import 'cart_bloc_test.mocks.dart';

@GenerateMocks([
  GetCartedItemsUseCase,
  GetAllCartedItemsDetailsByIdUseCase,
  RemoveProductFromCartUseCase,
  SetCartDetailsToPurchaseHistoryAndDeleteCartUseCase,
])
void main() {
  late CartBloc cartBloc;
  late MockGetCartedItemsUseCase mockGetCartedItemsUseCase;
  late MockGetAllCartedItemsDetailsByIdUseCase
      mockGetAllCartedItemsDetailsByIdUseCase;
  late MockRemoveProductFromCartUseCase mockRemoveProductFromCartUseCase;
  late MockSetCartDetailsToPurchaseHistoryAndDeleteCartUseCase
      mockSetCartDetailsToPurchaseHistoryAndDeleteCartUseCase;

  setUp(() {
    mockGetCartedItemsUseCase = MockGetCartedItemsUseCase();
    mockGetAllCartedItemsDetailsByIdUseCase =
        MockGetAllCartedItemsDetailsByIdUseCase();
    mockRemoveProductFromCartUseCase = MockRemoveProductFromCartUseCase();
    mockSetCartDetailsToPurchaseHistoryAndDeleteCartUseCase =
        MockSetCartDetailsToPurchaseHistoryAndDeleteCartUseCase();
    cartBloc = CartBloc(
      mockGetCartedItemsUseCase,
      mockGetAllCartedItemsDetailsByIdUseCase,
      mockRemoveProductFromCartUseCase,
      mockSetCartDetailsToPurchaseHistoryAndDeleteCartUseCase,
    );
  });

  tearDown(() {
    cartBloc.close();
  });

  blocTest<CartBloc, CartState>(
    'emits [loading, success, listOfCartedItems, listStatus success, totalPrice, subTotal, transactionFee] when GetAllCartedProductsDetailsByIdEvent is added and use case return list of product entities and added CountTotalPriceEvent',
    build: () {
      when(mockGetAllCartedItemsDetailsByIdUseCase.call(any))
          .thenAnswer((_) async => Right(cartedProductEntities));
      return cartBloc;
    },
    act: (bloc) => bloc.add(GetAllCartedProductsDetailsByIdEvent()),
    expect: () => [
      CartState(status: BlocStatus.loading),
      CartState(
        status: BlocStatus.success,
        listStatus: BlocStatus.success,
        listOfCartedItems: cartedProductEntities,
      ),
      CartState(
        status: BlocStatus.success,
        listStatus: BlocStatus.success,
        listOfCartedItems: cartedProductEntities,
        subTotal: cartedProductEntitiesListSubTotal,
        transactionFee: cartedProductEntitiesListTransactionFee,
        totalPrice: cartedProductEntitiesListTotalPrice,
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [loading, error, message] when GetAllCartedProductsDetailsByIdEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get all carted product details by ids failed',
      );

      when(mockGetAllCartedItemsDetailsByIdUseCase.call(any))
          .thenAnswer((_) async => Left(failure));
      return cartBloc;
    },
    act: (bloc) => bloc.add(GetAllCartedProductsDetailsByIdEvent()),
    expect: () => [
      CartState(status: BlocStatus.loading),
      CartState(
        status: BlocStatus.error,
        message: 'Get all carted product details by ids failed',
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [success, message] when DeleteCartedProductEvent is added and use case return success',
    build: () {
      when(mockRemoveProductFromCartUseCase.call(cartedProductId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));
      return cartBloc;
    },
    act: (bloc) => bloc.add(DeleteCartedProductEvent(id: cartedProductId)),
    expect: () => [
      CartState(
        listStatus: BlocStatus.success,
        message: CURDTypes.remove.curd,
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [error, message] when DeleteCartedProductEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Delete carted item failed',
      );

      when(mockRemoveProductFromCartUseCase.call(cartedProductId))
          .thenAnswer((_) async => Left(failure));
      return cartBloc;
    },
    act: (bloc) => bloc.add(DeleteCartedProductEvent(id: cartedProductId)),
    expect: () => [
      CartState(
        listStatus: BlocStatus.error,
        message: 'Delete carted item failed',
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits updated state with message when SetCartStateToDefaultEvent is added',
    build: () => cartBloc,
    act: (bloc) => bloc.add(SetCartStateToDefaultEvent()),
    expect: () => [
      CartState().copyWith(
        message: '',
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [success, listOfCartedItems, totalPrice, subTotal, transactionFee] when UpdateCartedProductsDetailsByIdEvent is added and use case return list of product entities and added CountTotalPriceEvent',
    build: () {
      when(mockGetAllCartedItemsDetailsByIdUseCase.call(any))
          .thenAnswer((_) async => Right(cartedProductEntities));
      return cartBloc;
    },
    act: (bloc) => bloc.add(UpdateCartedProductsDetailsByIdEvent()),
    expect: () => [
      CartState(
        listStatus: BlocStatus.success,
        listOfCartedItems: cartedProductEntities,
      ),
      CartState(
        listStatus: BlocStatus.success,
        listOfCartedItems: cartedProductEntities,
        subTotal: cartedProductEntitiesListSubTotal,
        transactionFee: cartedProductEntitiesListTransactionFee,
        totalPrice: cartedProductEntitiesListTotalPrice,
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [error, message] when UpdateCartedProductsDetailsByIdEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Update carted product details by ids failed',
      );

      when(mockGetAllCartedItemsDetailsByIdUseCase.call(any))
          .thenAnswer((_) async => Left(failure));
      return cartBloc;
    },
    act: (bloc) => bloc.add(UpdateCartedProductsDetailsByIdEvent()),
    expect: () => [
      CartState(
        listStatus: BlocStatus.error,
        message: 'Update carted product details by ids failed',
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [success] when SetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent is added and use case return success',
    build: () {
      cartBloc.emit(cartBloc.state
          .copyWith(totalPrice: cartedProductEntitiesListTotalPrice));

      when(mockSetCartDetailsToPurchaseHistoryAndDeleteCartUseCase
              .call(cartedProductEntitiesListTotalPrice.toString()))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));
      return cartBloc;
    },
    act: (bloc) =>
        bloc.add(SetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent()),
    expect: () => [
      CartState(
        totalPrice: cartedProductEntitiesListTotalPrice,
        addToPurchaseStatus: BlocStatus.success,
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [error, message] when SetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent fails',
    build: () {
      cartBloc.emit(cartBloc.state
          .copyWith(totalPrice: cartedProductEntitiesListTotalPrice));

      final failure = FirebaseFailure(
        errorMessage:
            'Set cart details to purchase history and delete cart failed',
      );

      when(mockSetCartDetailsToPurchaseHistoryAndDeleteCartUseCase
              .call(cartedProductEntitiesListTotalPrice.toString()))
          .thenAnswer((_) async => Left(failure));
      return cartBloc;
    },
    act: (bloc) =>
        bloc.add(SetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent()),
    expect: () => [
      CartState(
        totalPrice: cartedProductEntitiesListTotalPrice,
        addToPurchaseStatus: BlocStatus.error,
        addToPurchaseMessage:
            'Set cart details to purchase history and delete cart failed',
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits updated state with addToPurchaseMessage, addToPurchaseStatus, subTotal, transactionFee and totalPrice when SetAddToPurchaseStatusToDefault is added',
    build: () => cartBloc,
    act: (bloc) => bloc.add(SetAddToPurchaseStatusToDefault()),
    expect: () => [
      CartState().copyWith(
        addToPurchaseMessage: '',
        addToPurchaseStatus: BlocStatus.initial,
        subTotal: 0.0,
        transactionFee: 0.0,
        totalPrice: 0.0,
      ),
    ],
  );
}

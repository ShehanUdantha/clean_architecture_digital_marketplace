import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/cart/cart_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/cart/cart_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/cart_values.dart';
import 'cart_repository_impl_test.mocks.dart';

@GenerateMocks([CartRemoteDataSource])
void main() {
  late CartRepositoryImpl cartRepositoryImpl;
  late MockCartRemoteDataSource mockCartRemoteDataSource;

  setUp(() {
    mockCartRemoteDataSource = MockCartRemoteDataSource();
    cartRepositoryImpl =
        CartRepositoryImpl(cartRemoteDataSource: mockCartRemoteDataSource);
  });

  group(
    'addProductToCart',
    () {
      test(
        'should return a Success Status when the add product to cart process is successful',
        () async {
          // Arrange
          when(mockCartRemoteDataSource.addProductToCart(cartedProductId))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await cartRepositoryImpl.addProductToCart(cartedProductId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the add product to cart process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Add product to cart failed',
          );
          when(mockCartRemoteDataSource.addProductToCart(cartedProductId))
              .thenThrow(dbException);

          // Act
          final result =
              await cartRepositoryImpl.addProductToCart(cartedProductId);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Add product to cart failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAllCartedItemsDetailsByUserId',
    () {
      test(
        'should return a List of Products when the get all carted items details by id process is successful',
        () async {
          // Arrange
          when(mockCartRemoteDataSource.getAllCartedItemsDetailsById())
              .thenAnswer((_) async => cartedProductModels);

          // Act
          final result = await cartRepositoryImpl.getAllCartedItemsDetails();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, cartedProductModels),
          );
        },
      );

      test(
        'should return a Failure when the get all carted items details by id process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all carted items details by id failed',
          );
          when(mockCartRemoteDataSource.getAllCartedItemsDetailsById())
              .thenThrow(dbException);

          // Act
          final result = await cartRepositoryImpl.getAllCartedItemsDetails();

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all carted items details by id failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getCartedItemsIds',
    () {
      test(
        'should return a List of Carted Items Ids when the get carted items process is successful',
        () async {
          // Arrange
          when(mockCartRemoteDataSource.getCartedItems())
              .thenAnswer((_) async => cartedProductsIds);

          // Act
          final result = await cartRepositoryImpl.getCartedItems();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, cartedProductsIds),
          );
        },
      );

      test(
        'should return a Failure when the get carted items process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get carted items failed',
          );
          when(mockCartRemoteDataSource.getCartedItems())
              .thenThrow(dbException);

          // Act
          final result = await cartRepositoryImpl.getCartedItems();

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get carted items failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'removeProductFromCart',
    () {
      test(
        'should return a Success Status when the remove product from cart process is successful',
        () async {
          // Arrange
          when(mockCartRemoteDataSource.removeProductFromCart(cartedProductId))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await cartRepositoryImpl.removeProductFromCart(cartedProductId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the remove product from cart process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Remove product from cart failed',
          );
          when(mockCartRemoteDataSource.removeProductFromCart(cartedProductId))
              .thenThrow(dbException);

          // Act
          final result =
              await cartRepositoryImpl.removeProductFromCart(cartedProductId);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Remove product from cart failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'setCartDetailsToPurchaseHistoryAndDeleteCart',
    () {
      test(
        'should return a Success Status when the set cart details to purchase history and delete cart process is successful',
        () async {
          // Arrange
          when(mockCartRemoteDataSource
                  .setCartDetailsToPurchaseHistoryAndDeleteCart(
                      cartedProductEntitiesListSubTotal.toString()))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await cartRepositoryImpl
              .setCartDetailsToPurchaseHistoryAndDeleteCart(
                  cartedProductEntitiesListSubTotal.toString());

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the set cart details to purchase history and delete cart process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage:
                'Set cart details to purchase history and delete cart failed',
          );
          when(mockCartRemoteDataSource
                  .setCartDetailsToPurchaseHistoryAndDeleteCart(
                      cartedProductEntitiesListSubTotal.toString()))
              .thenThrow(dbException);

          // Act
          final result = await cartRepositoryImpl
              .setCartDetailsToPurchaseHistoryAndDeleteCart(
                  cartedProductEntitiesListSubTotal.toString());

          // Assert
          final failure = FirebaseFailure(
            errorMessage:
                'Set cart details to purchase history and delete cart failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );
}

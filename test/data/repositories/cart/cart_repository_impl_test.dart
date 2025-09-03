import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/services/network_service.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/cart/cart_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/cart/cart_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/cart_values.dart';
import 'cart_repository_impl_test.mocks.dart';

@GenerateMocks([CartRemoteDataSource, NetworkService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CartRepositoryImpl cartRepositoryImpl;
  late MockCartRemoteDataSource mockCartRemoteDataSource;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockCartRemoteDataSource = MockCartRemoteDataSource();
    mockNetworkService = MockNetworkService();
    cartRepositoryImpl = CartRepositoryImpl(
      cartRemoteDataSource: mockCartRemoteDataSource,
      networkService: mockNetworkService,
    );
  });

  group(
    'addProductToCart',
    () {
      test(
        'should return a Success Status when the add product to cart process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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

      test(
        'should return a Failure when network fails in the add product to cart process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await cartRepositoryImpl.addProductToCart(cartedProductId);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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

      test(
        'should return a Failure when network fails in the get all carted items details by id process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await cartRepositoryImpl.getAllCartedItemsDetails();

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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

      test(
        'should return a Failure when network fails in the get carted items process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await cartRepositoryImpl.getCartedItems();

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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

      test(
        'should return a Failure when network fails in the remove product from cart process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await cartRepositoryImpl.removeProductFromCart(cartedProductId);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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

      test(
        'should return a Failure when network fails in the set cart details to purchase history and delete cart process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await cartRepositoryImpl
              .setCartDetailsToPurchaseHistoryAndDeleteCart(
                  cartedProductEntitiesListSubTotal.toString());

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );
}

import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/cart/cart_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/add_product_to_cart_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/cart_values.dart';
import 'add_product_to_cart_usecase_test.mocks.dart';

@GenerateMocks([CartRepository])
void main() {
  late AddProductToCartUseCase addProductToCartUseCase;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    addProductToCartUseCase =
        AddProductToCartUseCase(cartRepository: mockCartRepository);
  });

  test(
    'should return a Success Status when the add product to cart process is successful',
    () async {
      // Arrange
      when(mockCartRepository.addProductToCart(cartedProductId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await addProductToCartUseCase.call(cartedProductId);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the add product to cart process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Add product to cart failed',
      );
      when(mockCartRepository.addProductToCart(cartedProductId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await addProductToCartUseCase.call(cartedProductId);

      // Assert
      expect(result, Left(failure));
    },
  );
}

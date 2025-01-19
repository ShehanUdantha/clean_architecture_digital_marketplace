import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/cart/cart_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/remove_product_from_cart_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'remove_product_from_cart_usecase_test.mocks.dart';

@GenerateMocks([CartRepository])
void main() {
  late RemoveProductFromCartUseCase removeProductFromCartUseCase;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    removeProductFromCartUseCase =
        RemoveProductFromCartUseCase(cartRepository: mockCartRepository);
  });

  test(
    'should return a Success Status when the remove product from cart process is successful',
    () async {
      // Arrange
      when(mockCartRepository.removeProductFromCart(fakeProductId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await removeProductFromCartUseCase.call(fakeProductId);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the remove product from cart process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Remove product from cart failed',
      );
      when(mockCartRepository.removeProductFromCart(fakeProductId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await removeProductFromCartUseCase.call(fakeProductId);

      // Assert
      expect(result, Left(failure));
    },
  );
}

import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/cart/cart_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/set_cart_details_to_purchase_history_and_delete_cart_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/cart_values.dart';
import 'set_cart_details_to_purchase_history_and_delete_cart_usecase_test.mocks.dart';

@GenerateMocks([CartRepository])
void main() {
  late SetCartDetailsToPurchaseHistoryAndDeleteCartUseCase
      setCartDetailsToPurchaseHistoryAndDeleteCartUseCase;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    setCartDetailsToPurchaseHistoryAndDeleteCartUseCase =
        SetCartDetailsToPurchaseHistoryAndDeleteCartUseCase(
            cartRepository: mockCartRepository);
  });

  test(
    'should return a Success Status when the set cart details to purchase history and delete cart process is successful',
    () async {
      // Arrange
      when(mockCartRepository.setCartDetailsToPurchaseHistoryAndDeleteCart(
              cartedProductEntitiesListSubTotal.toString()))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await setCartDetailsToPurchaseHistoryAndDeleteCartUseCase
          .call(cartedProductEntitiesListSubTotal.toString());

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the set cart details to purchase history and delete cart process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage:
            'Set cart details to purchase history and delete cart failed',
      );
      when(mockCartRepository.setCartDetailsToPurchaseHistoryAndDeleteCart(
              cartedProductEntitiesListSubTotal.toString()))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await setCartDetailsToPurchaseHistoryAndDeleteCartUseCase
          .call(cartedProductEntitiesListSubTotal.toString());

      // Assert
      expect(result, Left(failure));
    },
  );
}

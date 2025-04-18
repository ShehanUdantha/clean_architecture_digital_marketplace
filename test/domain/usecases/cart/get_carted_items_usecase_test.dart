import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/usecases/usecase.dart';
import 'package:Pixelcart/src/domain/repositories/cart/cart_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/get_carted_items_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/cart_values.dart';
import 'get_carted_items_usecase_test.mocks.dart';

@GenerateMocks([CartRepository])
void main() {
  late GetCartedItemsUseCase getCartedItemsUseCase;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    getCartedItemsUseCase =
        GetCartedItemsUseCase(cartRepository: mockCartRepository);
  });

  test(
    'should return a List of Carted Items Ids when the get carted items process is successful',
    () async {
      // Arrange
      when(mockCartRepository.getCartedItems())
          .thenAnswer((_) async => Right(cartedProductsIds));

      // Act
      final result = await getCartedItemsUseCase.call(NoParams());

      // Assert
      expect(result, Right(cartedProductsIds));
    },
  );

  test(
    'should return a Failure when the get carted items process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get carted items failed',
      );
      when(mockCartRepository.getCartedItems())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getCartedItemsUseCase.call(NoParams());

      // Assert
      expect(result, Left(failure));
    },
  );
}

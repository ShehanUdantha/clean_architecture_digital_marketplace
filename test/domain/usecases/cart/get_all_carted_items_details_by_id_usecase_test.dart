import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/usecases/usecase.dart';
import 'package:Pixelcart/src/domain/repositories/cart/cart_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/get_all_carted_items_details_by_id_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/cart_values.dart';
import 'get_all_carted_items_details_by_id_usecase_test.mocks.dart';

@GenerateMocks([CartRepository])
void main() {
  late GetAllCartedItemsDetailsByIdUseCase getAllCartedItemsDetailsByIdUseCase;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    getAllCartedItemsDetailsByIdUseCase =
        GetAllCartedItemsDetailsByIdUseCase(cartRepository: mockCartRepository);
  });

  test(
    'should return a List of Products when the get all carted items details by id process is successful',
    () async {
      // Arrange
      when(mockCartRepository.getAllCartedItemsDetails())
          .thenAnswer((_) async => Right(cartedProductEntities));

      // Act
      final result = await getAllCartedItemsDetailsByIdUseCase.call(NoParams());

      // Assert
      expect(result, Right(cartedProductEntities));
    },
  );

  test(
    'should return a Failure when the get all carted items details by id process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all carted items details by id failed',
      );
      when(mockCartRepository.getAllCartedItemsDetails())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllCartedItemsDetailsByIdUseCase.call(NoParams());

      // Assert
      expect(result, Left(failure));
    },
  );
}

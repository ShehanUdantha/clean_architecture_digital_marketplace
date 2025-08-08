import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/cart/purchase_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_items_by_product_id_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/purchase_values.dart';
import 'get_all_purchase_items_by_product_id_usecase_test.mocks.dart';

@GenerateMocks([PurchaseRepository])
void main() {
  late GetAllPurchaseItemsByItsProductIdsUseCase
      getAllPurchaseItemsByItsProductIdsUseCase;
  late MockPurchaseRepository mockPurchaseRepository;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    getAllPurchaseItemsByItsProductIdsUseCase =
        GetAllPurchaseItemsByItsProductIdsUseCase(
            purchaseRepository: mockPurchaseRepository);
  });

  test(
    'should return a List of ProductsModels when the get all purchase items by product id process is successful',
    () async {
      // Arrange
      when(mockPurchaseRepository
              .getAllPurchaseItemsByProductId(purchasedEntity))
          .thenAnswer((_) async => Right(purchasedProductEntities));

      // Act
      final result =
          await getAllPurchaseItemsByItsProductIdsUseCase.call(purchasedEntity);

      // Assert
      expect(result, Right(purchasedProductEntities));
    },
  );

  test(
    'should return a Failure when the get all purchase items by product id process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all purchase items by product id failed',
      );
      when(mockPurchaseRepository
              .getAllPurchaseItemsByProductId(purchasedEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getAllPurchaseItemsByItsProductIdsUseCase.call(purchasedEntity);

      // Assert
      expect(result, Left(failure));
    },
  );
}

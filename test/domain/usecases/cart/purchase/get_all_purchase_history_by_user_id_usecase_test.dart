import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/usecases/usecase.dart';
import 'package:Pixelcart/src/domain/repositories/cart/purchase_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_history_by_user_id_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/purchase_values.dart';
import 'get_all_purchase_history_by_user_id_usecase_test.mocks.dart';

@GenerateMocks([PurchaseRepository])
void main() {
  late GetAllPurchaseHistoryByUserIdUseCase
      getAllPurchaseHistoryByUserIdUseCase;
  late MockPurchaseRepository mockPurchaseRepository;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    getAllPurchaseHistoryByUserIdUseCase = GetAllPurchaseHistoryByUserIdUseCase(
        purchaseRepository: mockPurchaseRepository);
  });

  test(
    'should return a List of PurchaseProductsModels when the get all purchase history by user id process is successful',
    () async {
      // Arrange
      when(mockPurchaseRepository.getAllPurchaseHistoryByUserId())
          .thenAnswer((_) async => Right(purchaseEntities));

      // Act
      final result =
          await getAllPurchaseHistoryByUserIdUseCase.call(NoParams());

      // Assert
      expect(result, Right(purchaseEntities));
    },
  );

  test(
    'should return a Failure when the get all purchase history by user id process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all purchase history by user id failed',
      );
      when(mockPurchaseRepository.getAllPurchaseHistoryByUserId())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getAllPurchaseHistoryByUserIdUseCase.call(NoParams());

      // Assert
      expect(result, Left(failure));
    },
  );
}

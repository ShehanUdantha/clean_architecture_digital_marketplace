import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/cart/purchase_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_history_by_month_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/purchase_values.dart';
import 'get_all_purchase_history_by_month_usecase_test.mocks.dart';

@GenerateMocks([PurchaseRepository])
void main() {
  late GetAllPurchaseHistoryByMonthUseCase getAllPurchaseHistoryByMonthUseCase;
  late MockPurchaseRepository mockPurchaseRepository;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    getAllPurchaseHistoryByMonthUseCase = GetAllPurchaseHistoryByMonthUseCase(
        purchaseRepository: mockPurchaseRepository);
  });

  test(
    'should return a Map of purchase history for the provided month when the get all purchase history by month process is successful',
    () async {
      // Arrange
      when(mockPurchaseRepository.getAllPurchaseHistoryByMonth(
              yearAndMonthParamsToGetPurchaseHistory))
          .thenAnswer((_) async => Right(purchaseHistoryByYearAndMonth));

      // Act
      final result = await getAllPurchaseHistoryByMonthUseCase
          .call(yearAndMonthParamsToGetPurchaseHistory);

      // Assert
      expect(result, Right(purchaseHistoryByYearAndMonth));
    },
  );

  test(
    'should return a Failure when the get all purchase history by month process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all purchase history by month failed',
      );
      when(mockPurchaseRepository.getAllPurchaseHistoryByMonth(
              yearAndMonthParamsToGetPurchaseHistory))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllPurchaseHistoryByMonthUseCase
          .call(yearAndMonthParamsToGetPurchaseHistory);

      // Assert
      expect(result, Left(failure));
    },
  );
}

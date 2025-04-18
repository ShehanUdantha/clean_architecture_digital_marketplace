import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/cart/purchase_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_total_balance_by_month_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/purchase_values.dart';
import 'get_all_purchase_total_balance_by_month_usecase_test.mocks.dart';

@GenerateMocks([PurchaseRepository])
void main() {
  late GetAllPurchaseBalanceByMonthUseCase getAllPurchaseBalanceByMonthUseCase;
  late MockPurchaseRepository mockPurchaseRepository;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    getAllPurchaseBalanceByMonthUseCase = GetAllPurchaseBalanceByMonthUseCase(
        purchaseRepository: mockPurchaseRepository);
  });

  test(
    'should return a Total purchase amount for the provided month when the get all purchase total balance by month process is successful',
    () async {
      // Arrange
      when(mockPurchaseRepository.getAllPurchasesTotalBalanceByMonth(
              yearAndMonthParamsToGetPurchaseHistory))
          .thenAnswer((_) async => Right(totalPurchaseAmountByYearAndMonth));

      // Act
      final result = await getAllPurchaseBalanceByMonthUseCase
          .call(yearAndMonthParamsToGetPurchaseHistory);

      // Assert
      expect(result, Right(totalPurchaseAmountByYearAndMonth));
    },
  );

  test(
    'should return a Failure when the get all purchase total balance by month process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all purchase total balance by month failed',
      );
      when(mockPurchaseRepository.getAllPurchasesTotalBalanceByMonth(
              yearAndMonthParamsToGetPurchaseHistory))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllPurchaseBalanceByMonthUseCase
          .call(yearAndMonthParamsToGetPurchaseHistory);

      // Assert
      expect(result, Left(failure));
    },
  );
}

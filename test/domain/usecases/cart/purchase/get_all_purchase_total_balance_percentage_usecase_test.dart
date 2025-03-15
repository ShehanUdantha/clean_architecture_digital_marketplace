import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/cart/purchase_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_total_balance_percentage_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/constant_values.dart';
import 'get_all_purchase_total_balance_percentage_usecase_test.mocks.dart';

@GenerateMocks([PurchaseRepository])
void main() {
  late GetAllPurchaseBalancePercentageByMonthUseCase
      getAllPurchaseBalancePercentageByMonthUseCase;
  late MockPurchaseRepository mockPurchaseRepository;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    getAllPurchaseBalancePercentageByMonthUseCase =
        GetAllPurchaseBalancePercentageByMonthUseCase(
            purchaseRepository: mockPurchaseRepository);
  });

  test(
    'should return a Total purchase amount percentage for the provided month when the get all purchase total balance percentage by month process is successful',
    () async {
      // Arrange
      when(mockPurchaseRepository
              .getAllPurchasesTotalBalancePercentageByMonth(yearAndMonthParams))
          .thenAnswer((_) async => Right(fakeTotalPurchaseAmountPercentage));

      // Act
      final result = await getAllPurchaseBalancePercentageByMonthUseCase
          .call(yearAndMonthParams);

      // Assert
      expect(result, Right(fakeTotalPurchaseAmountPercentage));
    },
  );

  test(
    'should return a Failure when the get all purchase total balance percentage by month process fails due to the unauthorized access',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage:
            'Get all purchase total balance percentage by month failed - due to the unauthorized access',
      );
      when(mockPurchaseRepository.getAllPurchasesTotalBalancePercentageByMonth(
              yearAndMonthParamsTwo))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllPurchaseBalancePercentageByMonthUseCase
          .call(yearAndMonthParamsTwo);

      // Assert
      expect(result, Left(failure));
    },
  );

  test(
    'should return a Failure when the get all purchase total balance percentage by month process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage:
            'Get all purchase total balance percentage by month failed',
      );
      when(mockPurchaseRepository
              .getAllPurchasesTotalBalancePercentageByMonth(yearAndMonthParams))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllPurchaseBalancePercentageByMonthUseCase
          .call(yearAndMonthParams);

      // Assert
      expect(result, Left(failure));
    },
  );
}

import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/cart/purchase_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_top_sellings_products_by_month_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/constant_values.dart';
import 'get_top_sellings_products_by_month_usecase_test.mocks.dart';

@GenerateMocks([PurchaseRepository])
void main() {
  late GetTopSellingProductsByMonthUseCase getTopSellingProductsByMonthUseCase;
  late MockPurchaseRepository mockPurchaseRepository;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    getTopSellingProductsByMonthUseCase = GetTopSellingProductsByMonthUseCase(
        purchaseRepository: mockPurchaseRepository);
  });

  test(
    'should return a List of top selling products for the provided month when the get top selling products by month process is successful',
    () async {
      // Arrange
      when(mockPurchaseRepository.getAllTopSellingProductsByMonth(
              fakePurchaseYear, fakePurchaseMonth))
          .thenAnswer((_) async => Right(dummyTopSellingProducts));

      // Act
      final result =
          await getTopSellingProductsByMonthUseCase.call(yearAndMonthParams);

      // Assert
      expect(result, Right(dummyTopSellingProducts));
    },
  );

  test(
    'should return a Failure when the get top selling products by month process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get top selling products by month failed',
      );
      when(mockPurchaseRepository.getAllTopSellingProductsByMonth(
              fakePurchaseYear, fakePurchaseMonth))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getTopSellingProductsByMonthUseCase.call(yearAndMonthParams);

      // Assert
      expect(result, Left(failure));
    },
  );
}

import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/cart/purchase_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/download_product_by_product_id_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/purchase_values.dart';
import 'download_product_by_product_id_usecase_test.mocks.dart';

@GenerateMocks([PurchaseRepository])
void main() {
  late DownloadProductByProductIdUsecase downloadProductByProductIdUsecase;
  late MockPurchaseRepository mockPurchaseRepository;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    downloadProductByProductIdUsecase = DownloadProductByProductIdUsecase(
        purchaseRepository: mockPurchaseRepository);
  });

  test(
    'should return a Product file URL when the download product by product id process is successful',
    () async {
      // Arrange
      when(mockPurchaseRepository
              .downloadProductByProductId(purchasedProductId))
          .thenAnswer((_) async => Right(purchasedProductUrl));

      // Act
      final result =
          await downloadProductByProductIdUsecase.call(purchasedProductId);

      // Assert
      expect(result, Right(purchasedProductUrl));
    },
  );

  test(
    'should return a Failure when the download product by product id process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Download product by product id failed',
      );
      when(mockPurchaseRepository
              .downloadProductByProductId(purchasedProductId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await downloadProductByProductIdUsecase.call(purchasedProductId);

      // Assert
      expect(result, Left(failure));
    },
  );
}

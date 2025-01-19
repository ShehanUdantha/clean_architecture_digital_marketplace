import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/cart/purchase_repository.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/download_product_by_product_id_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/constant_values.dart';
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
    'should return a Success Status when the download product by product id process is successful',
    () async {
      // Arrange
      when(mockPurchaseRepository.downloadProductByProductId(fakeProductId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result =
          await downloadProductByProductIdUsecase.call(fakeProductId);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the download product by product id process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Download product by product id failed',
      );
      when(mockPurchaseRepository.downloadProductByProductId(fakeProductId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await downloadProductByProductIdUsecase.call(fakeProductId);

      // Assert
      expect(result, Left(failure));
    },
  );
}

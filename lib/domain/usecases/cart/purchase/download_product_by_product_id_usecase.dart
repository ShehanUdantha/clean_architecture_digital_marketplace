import 'package:Pixelcart/core/error/failure.dart';
import 'package:Pixelcart/core/usecases/usecase.dart';
import 'package:Pixelcart/domain/repositories/cart/purchase_repository.dart';
import 'package:dartz/dartz.dart';

class DownloadProductByProductIdUsecase extends UseCase<String, String> {
  final PurchaseRepository purchaseRepository;

  DownloadProductByProductIdUsecase({required this.purchaseRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await purchaseRepository.downloadProductByProductId(params);
  }
}

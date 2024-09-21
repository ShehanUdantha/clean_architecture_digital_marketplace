import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../repositories/cart/purchase_repository.dart';
import 'package:dartz/dartz.dart';

class DownloadProductByProductIdUsecase extends UseCase<String, String> {
  final PurchaseRepository purchaseRepository;

  DownloadProductByProductIdUsecase({required this.purchaseRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await purchaseRepository.downloadProductByProductId(params);
  }
}

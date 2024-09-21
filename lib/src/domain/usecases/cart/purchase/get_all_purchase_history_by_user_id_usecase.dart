import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../entities/product/purchase_products_entity.dart';
import '../../../repositories/cart/purchase_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllPurchaseHistoryByUserIdUseCase
    extends UseCase<List<PurchaseProductsEntity>, NoParams> {
  final PurchaseRepository purchaseRepository;

  GetAllPurchaseHistoryByUserIdUseCase({required this.purchaseRepository});

  @override
  Future<Either<Failure, List<PurchaseProductsEntity>>> call(
      NoParams params) async {
    return await purchaseRepository.getAllPurchaseHistoryByUserId();
  }
}

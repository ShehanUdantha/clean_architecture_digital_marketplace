import 'package:Pixelcart/core/error/failure.dart';
import 'package:Pixelcart/core/usecases/usecase.dart';
import 'package:Pixelcart/domain/entities/product/purchase_products_entity.dart';
import 'package:Pixelcart/domain/repositories/cart/purchase_repository.dart';
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

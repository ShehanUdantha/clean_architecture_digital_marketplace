import '../../../entities/cart/purchase_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../entities/product/product_entity.dart';
import '../../../repositories/cart/purchase_repository.dart';

class GetAllPurchaseItemsByItsProductIdsUseCase
    extends UseCase<List<ProductEntity>, PurchaseEntity> {
  final PurchaseRepository purchaseRepository;
  GetAllPurchaseItemsByItsProductIdsUseCase({required this.purchaseRepository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
      PurchaseEntity params) async {
    return await purchaseRepository.getAllPurchaseItemsByProductId(params);
  }
}

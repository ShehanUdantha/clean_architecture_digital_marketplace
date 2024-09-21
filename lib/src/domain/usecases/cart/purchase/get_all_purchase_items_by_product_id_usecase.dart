import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../entities/product/product_entity.dart';
import '../../../repositories/cart/purchase_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllPurchaseItemsByProductIdUseCase
    extends UseCase<List<ProductEntity>, List<String>> {
  final PurchaseRepository purchaseRepository;
  GetAllPurchaseItemsByProductIdUseCase({required this.purchaseRepository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(List<String> params) async {
    return await purchaseRepository.getAllPurchaseItemsByProductId(params);
  }
}

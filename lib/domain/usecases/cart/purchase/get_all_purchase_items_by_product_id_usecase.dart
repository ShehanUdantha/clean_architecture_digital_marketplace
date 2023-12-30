import 'package:Pixelcart/core/error/failure.dart';
import 'package:Pixelcart/core/usecases/usecase.dart';
import 'package:Pixelcart/domain/entities/product/product_entity.dart';
import 'package:Pixelcart/domain/repositories/cart/purchase_repository.dart';
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

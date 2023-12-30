import 'package:Pixelcart/core/error/failure.dart';
import 'package:Pixelcart/core/usecases/usecase.dart';
import 'package:Pixelcart/domain/entities/product/product_entity.dart';
import 'package:Pixelcart/domain/repositories/cart/cart_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCartedItemsDetailsByIdUseCase
    extends UseCase<List<ProductEntity>, NoParams> {
  final CartRepository cartRepository;

  GetAllCartedItemsDetailsByIdUseCase({required this.cartRepository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) async {
    return await cartRepository.getAllCartedItemsDetails();
  }
}

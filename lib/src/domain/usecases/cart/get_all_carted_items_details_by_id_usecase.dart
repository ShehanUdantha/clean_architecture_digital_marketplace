import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/product/product_entity.dart';
import '../../repositories/cart/cart_repository.dart';
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

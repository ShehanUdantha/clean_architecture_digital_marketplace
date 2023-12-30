import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../repositories/cart/cart_repository.dart';
import 'package:dartz/dartz.dart';

class AddProductToCartUseCase extends UseCase<String, String> {
  final CartRepository cartRepository;

  AddProductToCartUseCase({required this.cartRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await cartRepository.addProductToCart(params);
  }
}

import '../../repositories/cart/cart_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';

class RemoveProductFromCartUseCase extends UseCase<String, String> {
  final CartRepository cartRepository;

  RemoveProductFromCartUseCase({required this.cartRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await cartRepository.removeProductFromCart(params);
  }
}

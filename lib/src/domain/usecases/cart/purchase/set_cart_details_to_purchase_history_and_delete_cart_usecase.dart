import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../repositories/cart/cart_repository.dart';
import 'package:dartz/dartz.dart';

class SetCartDetailsToPurchaseHistoryAndDeleteCartUseCase
    extends UseCase<String, String> {
  final CartRepository cartRepository;

  SetCartDetailsToPurchaseHistoryAndDeleteCartUseCase(
      {required this.cartRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await cartRepository
        .setCartDetailsToPurchaseHistoryAndDeleteCart(params);
  }
}

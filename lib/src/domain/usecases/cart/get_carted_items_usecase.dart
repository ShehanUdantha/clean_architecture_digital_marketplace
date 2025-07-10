import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/cart/cart_repository.dart';

class GetCartedItemsUseCase extends UseCase<List<String>, NoParams> {
  final CartRepository cartRepository;

  GetCartedItemsUseCase({required this.cartRepository});

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await cartRepository.getCartedItems();
  }
}

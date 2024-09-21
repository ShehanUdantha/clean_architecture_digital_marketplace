import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/product/product_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/product/product_entity.dart';

class AddFavoriteUseCase extends UseCase<ProductEntity, String> {
  final ProductRepository productRepository;

  AddFavoriteUseCase({required this.productRepository});

  @override
  Future<Either<Failure, ProductEntity>> call(String params) async {
    return await productRepository.addFavorite(params);
  }
}

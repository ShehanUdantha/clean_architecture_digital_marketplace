import 'package:Pixelcart/core/error/failure.dart';
import 'package:Pixelcart/core/usecases/usecase.dart';
import 'package:Pixelcart/domain/repositories/product/product_repository.dart';
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

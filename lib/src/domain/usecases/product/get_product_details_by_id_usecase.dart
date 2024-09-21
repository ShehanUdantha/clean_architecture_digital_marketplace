import '../../entities/product/product_entity.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';

import 'package:dartz/dartz.dart';

import '../../repositories/product/product_repository.dart';

class GetProductDetailsByIdUseCase extends UseCase<ProductEntity, String> {
  final ProductRepository productRepository;

  GetProductDetailsByIdUseCase({required this.productRepository});

  @override
  Future<Either<Failure, ProductEntity>> call(String params) async {
    return await productRepository.getProductDetailsById(params);
  }
}

import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/product/product_entity.dart';
import '../../repositories/product/product_repository.dart';

class GetAllProductsUseCase extends UseCase<List<ProductEntity>, String> {
  final ProductRepository productRepository;

  GetAllProductsUseCase({required this.productRepository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(String params) async {
    return await productRepository.getAllProducts(params);
  }
}

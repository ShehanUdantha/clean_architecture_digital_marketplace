import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/product/product_entity.dart';
import '../../repositories/product/product_repository.dart';

class EditProductUseCase extends UseCase<String, ProductEntity> {
  final ProductRepository productRepository;

  EditProductUseCase({required this.productRepository});

  @override
  Future<Either<Failure, String>> call(ProductEntity params) async {
    return await productRepository.editProduct(params);
  }
}

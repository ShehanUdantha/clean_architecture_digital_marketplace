import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../entities/product/product_entity.dart';
import '../../repositories/product/product_repository.dart';
import 'package:dartz/dartz.dart';

class AddProductUseCase extends UseCase<String, ProductEntity> {
  final ProductRepository productRepository;

  AddProductUseCase({required this.productRepository});

  @override
  Future<Either<Failure, String>> call(ProductEntity params) async {
    return await productRepository.addProduct(params);
  }
}

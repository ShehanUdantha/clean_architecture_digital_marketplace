import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../entities/product/product_entity.dart';
import '../../repositories/product/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllProductsUseCase extends UseCase<List<ProductEntity>, String> {
  final ProductRepository productRepository;

  GetAllProductsUseCase({required this.productRepository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(String params) async {
    return await productRepository.getAllProducts(params);
  }
}

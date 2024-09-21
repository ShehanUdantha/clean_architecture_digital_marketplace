import '../../repositories/product/product_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';

class DeleteProductUseCase extends UseCase<String, String> {
  final ProductRepository productRepository;

  DeleteProductUseCase({required this.productRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await productRepository.deleteProduct(params);
  }
}

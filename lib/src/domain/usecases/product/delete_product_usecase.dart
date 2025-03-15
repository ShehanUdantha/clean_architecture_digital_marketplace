import '../../repositories/product/product_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import 'delete_product_params.dart';

class DeleteProductUseCase extends UseCase<String, DeleteProductParams> {
  final ProductRepository productRepository;

  DeleteProductUseCase({required this.productRepository});

  @override
  Future<Either<Failure, String>> call(DeleteProductParams params) async {
    return await productRepository.deleteProduct(params);
  }
}

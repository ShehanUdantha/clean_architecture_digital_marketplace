import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../repositories/product/product_repository.dart';
import 'package:dartz/dartz.dart';

import 'add_product_params.dart';

class AddProductUseCase extends UseCase<String, AddProductParams> {
  final ProductRepository productRepository;

  AddProductUseCase({required this.productRepository});

  @override
  Future<Either<Failure, String>> call(AddProductParams params) async {
    return await productRepository.addProduct(params);
  }
}

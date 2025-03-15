import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/product/product_repository.dart';
import 'edit_product_params.dart';

class EditProductUseCase extends UseCase<String, EditProductParams> {
  final ProductRepository productRepository;

  EditProductUseCase({required this.productRepository});

  @override
  Future<Either<Failure, String>> call(EditProductParams params) async {
    return await productRepository.editProduct(params);
  }
}

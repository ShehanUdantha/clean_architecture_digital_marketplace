import 'delete_category_params.dart';

import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../repositories/category/category_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteCategoryUseCase extends UseCase<String, DeleteCategoryParams> {
  final CategoryRepository categoryRepository;

  DeleteCategoryUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, String>> call(DeleteCategoryParams params) async {
    return await categoryRepository.deleteCategory(params);
  }
}

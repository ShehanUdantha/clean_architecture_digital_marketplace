import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/category/category_entity.dart';
import '../../repositories/category/category_repository.dart';

class GetAllCategoriesUseCase extends UseCase<List<CategoryEntity>, NoParams> {
  final CategoryRepository categoryRepository;

  GetAllCategoriesUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return await categoryRepository.getAllCategories();
  }
}

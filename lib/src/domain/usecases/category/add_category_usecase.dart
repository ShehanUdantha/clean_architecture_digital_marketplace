import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/category/category_repository.dart';

class AddCategoryUseCase extends UseCase<String, String> {
  final CategoryRepository categoryRepository;

  AddCategoryUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await categoryRepository.addCategory(params);
  }
}

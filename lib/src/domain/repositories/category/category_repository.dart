import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/category/category_entity.dart';
import '../../usecases/category/add_category_params.dart';
import '../../usecases/category/delete_category_params.dart';

abstract class CategoryRepository {
  Future<Either<Failure, String>> addCategory(
      AddCategoryParams addCategoryParams);
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, String>> deleteCategory(
      DeleteCategoryParams deleteCategoryParams);
}

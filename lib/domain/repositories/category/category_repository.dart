import '../../entities/category/category_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';

abstract class CategoryRepository {
  Future<Either<Failure, String>> addCategory(String name);
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, String>> deleteCategory(String id);
}

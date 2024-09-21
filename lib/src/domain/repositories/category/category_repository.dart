import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/category/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, String>> addCategory(String name);
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, String>> deleteCategory(String id);
}

import '../../entities/product/product_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, String>> addProduct(ProductEntity productEntity);
  Future<Either<Failure, List<ProductEntity>>> getAllProducts(String category);
  Future<Either<Failure, String>> deleteProduct(String productId);
  Future<Either<Failure, List<ProductEntity>>> getProductByMarketingTypes(
      String marketingType);
  Future<Either<Failure, List<ProductEntity>>> getProductsByQuery(String query);
  Future<Either<Failure, ProductEntity>> getProductDetailsById(
      String productId);
  Future<Either<Failure, ProductEntity>> addFavorite(String productId);
  Future<Either<Failure, String>> editProduct(ProductEntity productEntity);
}

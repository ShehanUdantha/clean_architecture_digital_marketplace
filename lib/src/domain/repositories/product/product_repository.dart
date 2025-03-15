import '../../entities/product/product_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../usecases/product/add_product_params.dart';
import '../../usecases/product/delete_product_params.dart';
import '../../usecases/product/edit_product_params.dart';

abstract class ProductRepository {
  Future<Either<Failure, String>> addProduct(AddProductParams addProductParams);
  Future<Either<Failure, List<ProductEntity>>> getAllProducts(String category);
  Future<Either<Failure, String>> deleteProduct(
      DeleteProductParams deleteProductParams);
  Future<Either<Failure, List<ProductEntity>>> getProductByMarketingTypes(
    String marketingType,
  );
  Future<Either<Failure, List<ProductEntity>>> getProductsByQuery(
    String query,
  );
  Future<Either<Failure, ProductEntity>> getProductDetailsById(
    String id,
  );
  Future<Either<Failure, ProductEntity>> addFavorite(String id);
  Future<Either<Failure, String>> editProduct(
      EditProductParams editProductParams);
}

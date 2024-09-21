import '../../entities/product/product_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';

abstract class CartRepository {
  Future<Either<Failure, String>> addProductToCart(String id);
  Future<Either<Failure, List<String>>> getCartedItems();
  Future<Either<Failure, List<ProductEntity>>> getAllCartedItemsDetails();
  Future<Either<Failure, String>> removeProductFromCart(String id);
  Future<Either<Failure, String>> setCartDetailsToPurchaseHistoryAndDeleteCart(
      String price);
}

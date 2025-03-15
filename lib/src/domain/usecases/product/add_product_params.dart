import '../../entities/product/product_entity.dart';

class AddProductParams {
  final ProductEntity productEntity;
  final String userId;

  const AddProductParams({
    required this.productEntity,
    required this.userId,
  });
}

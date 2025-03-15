import '../../entities/product/product_entity.dart';

class EditProductParams {
  final ProductEntity productEntity;
  final String userId;

  const EditProductParams({
    required this.productEntity,
    required this.userId,
  });
}

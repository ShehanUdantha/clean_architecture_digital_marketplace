// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class CategoryNameFieldChangeEvent extends ProductEvent {
  final String category;

  const CategoryNameFieldChangeEvent({required this.category});
}

class MarketingTypeFieldChangeEvent extends ProductEvent {
  final String type;

  const MarketingTypeFieldChangeEvent({required this.type});
}

class ProductUploadButtonClickedEvent extends ProductEvent {
  final Uint8List? coverImage;
  final List<Uint8List> subImages;
  final File? zipFile;
  final String productName;
  final String productPrice;
  final String productDescription;
  final String userId;

  const ProductUploadButtonClickedEvent({
    this.coverImage,
    required this.subImages,
    this.zipFile,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.userId,
  });
}

class ProductEditButtonClickedEvent extends ProductEvent {
  final String id;
  final dynamic coverImage;
  final List<Uint8List> subImages;
  final dynamic zipFile;
  final String productName;
  final String productPrice;
  final String productDescription;
  final List<String>? sharedSubImages;
  final List<String> likes;
  final String status;
  final String userId;

  const ProductEditButtonClickedEvent({
    required this.id,
    this.coverImage,
    required this.subImages,
    this.zipFile,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    this.sharedSubImages,
    required this.likes,
    required this.status,
    required this.userId,
  });
}

class SetProductAddAndEditStatusToDefault extends ProductEvent {}

class CategorySelectEvent extends ProductEvent {
  final int value;
  final String name;

  const CategorySelectEvent({
    required this.value,
    required this.name,
  });
}

class GetAllProductsEvent extends ProductEvent {}

class ProductDeleteEvent extends ProductEvent {
  final String productId;
  final String userId;

  const ProductDeleteEvent({
    required this.productId,
    required this.userId,
  });
}

class ProductEditEvent extends ProductEvent {}

class SetProductDeleteStateToDefault extends ProductEvent {}

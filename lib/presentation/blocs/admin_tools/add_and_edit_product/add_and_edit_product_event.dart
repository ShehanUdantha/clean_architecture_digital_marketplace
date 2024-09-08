// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_and_edit_product_bloc.dart';

sealed class AddAndEditProductEvent extends Equatable {
  const AddAndEditProductEvent();

  @override
  List<Object> get props => [];
}

class CategoryNameFieldChangeEvent extends AddAndEditProductEvent {
  final String category;

  const CategoryNameFieldChangeEvent({required this.category});
}

class MarketingTypeFieldChangeEvent extends AddAndEditProductEvent {
  final String type;

  const MarketingTypeFieldChangeEvent({required this.type});
}

class ProductUploadButtonClickedEvent extends AddAndEditProductEvent {
  final Uint8List? coverImage;
  final List<Uint8List> subImages;
  final File? zipFile;
  final String productName;
  final String productPrice;
  final String productDescription;

  const ProductUploadButtonClickedEvent({
    this.coverImage,
    required this.subImages,
    this.zipFile,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
  });
}

class SetProductStatusToDefault extends AddAndEditProductEvent {}

class ProductEditButtonClickedEvent extends AddAndEditProductEvent {
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
  });
}

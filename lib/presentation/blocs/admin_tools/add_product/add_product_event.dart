// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_product_bloc.dart';

sealed class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object> get props => [];
}

class CategoryNameFieldChangeEvent extends AddProductEvent {
  final String category;

  const CategoryNameFieldChangeEvent({required this.category});
}

class MarketingTypeFieldChangeEvent extends AddProductEvent {
  final String type;

  const MarketingTypeFieldChangeEvent({required this.type});
}

class ProductUploadButtonClickedEvent extends AddProductEvent {
  final Uint8List coverImage;
  final List<Uint8List> subImages;
  final File zipFile;
  final String productName;
  final String productPrice;
  final String productDescription;

  const ProductUploadButtonClickedEvent({
    required this.coverImage,
    required this.subImages,
    required this.zipFile,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
  });
}

class SetProductStatusToDefault extends AddProductEvent {}

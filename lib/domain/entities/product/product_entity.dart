import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String productName;
  final String price;
  final String category;
  final String marketingType;
  final String description;
  final dynamic coverImage;
  final dynamic subImages;
  final dynamic zipFile;
  final dynamic dateCreated;
  final List<String> likes;
  final String status;
  final List<String>? sharedSubImages;

  const ProductEntity({
    this.id,
    required this.productName,
    required this.price,
    required this.category,
    required this.marketingType,
    required this.description,
    required this.coverImage,
    required this.subImages,
    required this.zipFile,
    this.dateCreated,
    required this.likes,
    required this.status,
    this.sharedSubImages,
  });

  @override
  List<Object?> get props => [
        id,
        productName,
        price,
        category,
        marketingType,
        description,
        coverImage,
        subImages,
        zipFile,
        dateCreated,
        likes,
        status,
        sharedSubImages,
      ];
}

import '../../../domain/entities/product/product_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.productName,
    required super.price,
    required super.category,
    required super.marketingType,
    required super.description,
    required super.coverImage,
    required super.subImages,
    super.zipFile,
    required super.dateCreated,
    required super.likes,
    required super.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'productName': productName,
        'price': price,
        'category': category,
        'marketingType': marketingType,
        'description': description,
        'coverImage': coverImage,
        'subImages': subImages,
        'zipFile': zipFile,
        'dateCreated': dateCreated,
        'likes': likes,
        'status': status,
      };

  factory ProductModel.fromEntity(ProductEntity productEntity) => ProductModel(
        id: productEntity.id,
        productName: productEntity.productName,
        price: productEntity.price,
        category: productEntity.category,
        marketingType: productEntity.marketingType,
        description: productEntity.description,
        coverImage: productEntity.coverImage,
        subImages: productEntity.subImages,
        zipFile: productEntity.zipFile,
        dateCreated: productEntity.dateCreated,
        likes: productEntity.likes,
        status: productEntity.status,
      );

  factory ProductModel.fromMap(
    QueryDocumentSnapshot<Map<String, dynamic>> map,
  ) =>
      ProductModel(
        id: map['id'],
        productName: map['productName'],
        price: map['price'],
        category: map['category'],
        marketingType: map['marketingType'],
        description: map['description'],
        coverImage: map['coverImage'],
        subImages: map['subImages'],
        zipFile: map.data().containsKey('zipFile') ? map['zipFile'] : null,
        dateCreated: map['dateCreated'],
        likes: List<String>.from((map['likes'] as List).map((e) => e)),
        status: map['status'],
      );

  factory ProductModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return ProductModel(
      id: data['id'],
      productName: data['productName'],
      price: data['price'],
      category: data['category'],
      marketingType: data['marketingType'],
      description: data['description'],
      coverImage: data['coverImage'],
      subImages: data['subImages'],
      zipFile: data.containsKey('zipFile') ? data['zipFile'] : null,
      dateCreated: data['dateCreated'],
      likes: List<String>.from((data['likes'] as List).map((e) => e)),
      status: data['status'],
    );
  }
}

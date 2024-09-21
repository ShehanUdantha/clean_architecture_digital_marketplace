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
    required super.zipFile,
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
        zipFile: map['zipFile'],
        dateCreated: map['dateCreated'],
        likes: List<String>.from((map['likes'] as List).map((e) => e)),
        status: map['status'],
      );

  factory ProductModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) =>
      ProductModel(
        id: document['id'],
        productName: document['productName'],
        price: document['price'],
        category: document['category'],
        marketingType: document['marketingType'],
        description: document['description'],
        coverImage: document['coverImage'],
        subImages: document['subImages'],
        zipFile: document['zipFile'],
        dateCreated: document['dateCreated'],
        likes: List<String>.from((document['likes'] as List).map((e) => e)),
        status: document['status'],
      );
}

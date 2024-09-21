import '../../../domain/entities/product/purchase_products_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseProductsModel extends PurchaseProductsEntity {
  const PurchaseProductsModel({
    required super.purchaseId,
    required super.price,
    required super.dateCreated,
    required super.products,
  });

  factory PurchaseProductsModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      PurchaseProductsModel(
        purchaseId: map['purchaseId'],
        price: map['price'],
        dateCreated: map['date'],
        products: List<String>.from((map['ids'] as List).map((e) => e)),
      );

  factory PurchaseProductsModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) =>
      PurchaseProductsModel(
        purchaseId: document['purchaseId'],
        price: document['price'],
        dateCreated: document['date'],
        products: List<String>.from((document['ids'] as List).map((e) => e)),
      );
}

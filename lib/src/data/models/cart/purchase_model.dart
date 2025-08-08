import '../../../domain/entities/cart/purchase_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel extends PurchaseEntity {
  const PurchaseModel({
    required super.purchaseId,
    required super.price,
    required super.dateCreated,
    required super.products,
  });

  factory PurchaseModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      PurchaseModel(
        purchaseId: map['purchaseId'],
        price: map['price'],
        dateCreated: map['date'],
        products: List<String>.from((map['ids'] as List).map((e) => e)),
      );

  factory PurchaseModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) =>
      PurchaseModel(
        purchaseId: document['purchaseId'],
        price: document['price'],
        dateCreated: document['date'],
        products: List<String>.from((document['ids'] as List).map((e) => e)),
      );
}

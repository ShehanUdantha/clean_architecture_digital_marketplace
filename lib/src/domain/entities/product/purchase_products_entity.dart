import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PurchaseProductsEntity extends Equatable {
  final String purchaseId;
  final String price;
  final Timestamp dateCreated;
  final List<String> products;

  const PurchaseProductsEntity({
    required this.purchaseId,
    required this.price,
    required this.dateCreated,
    required this.products,
  });

  @override
  List<Object?> get props => [
        purchaseId,
        price,
        dateCreated,
        products,
      ];
}

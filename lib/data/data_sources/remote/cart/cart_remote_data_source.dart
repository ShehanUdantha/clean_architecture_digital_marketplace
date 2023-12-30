// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Pixelcart/core/utils/extension.dart';
import 'package:Pixelcart/data/models/product/product_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';

abstract class CartRemoteDataSource {
  Future<String> addProductToCart(String productId);
  Future<List<String>> getCartedItems();
  Future<String> removeProductFromCart(String productId);
  Future<List<ProductModel>> getAllCartedItemsDetailsById();
  Future<String> setCartDetailsToPurchaseHistoryAndDeleteCart(String price);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  CartRemoteDataSourceImpl({
    required this.fireStore,
    required this.auth,
  });

  @override
  Future<String> addProductToCart(String productId) async {
    try {
      final currentUser = auth.currentUser;
      try {
        final checkDocument =
            await fireStore.collection('cart').doc(currentUser!.uid).get();

        if (checkDocument.exists) {
          await fireStore.collection('cart').doc(currentUser.uid).update({
            'ids': FieldValue.arrayUnion([productId])
          });
        } else {
          await fireStore.collection('cart').doc(currentUser.uid).set({
            'ids': FieldValue.arrayUnion([productId])
          });
        }

        return ResponseTypes.success.response;
      } on FirebaseException catch (e) {
        throw DBException(errorMessage: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<String>> getCartedItems() async {
    try {
      final currentUser = auth.currentUser;
      try {
        final result =
            await fireStore.collection('cart').doc(currentUser!.uid).get();

        if (result.exists) {
          return List<String>.from(
            (result['ids'] as List).map((e) => e),
          ).toList();
        } else {
          return [];
        }
      } on FirebaseException catch (e) {
        throw DBException(errorMessage: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> removeProductFromCart(String productId) async {
    try {
      final currentUser = auth.currentUser;
      try {
        await fireStore.collection('cart').doc(currentUser!.uid).update({
          'ids': FieldValue.arrayRemove([productId])
        });

        return ResponseTypes.success.response;
      } on FirebaseException catch (e) {
        throw DBException(errorMessage: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getAllCartedItemsDetailsById() async {
    try {
      final currentUser = auth.currentUser;
      try {
        final cartedIdsDocuments =
            await fireStore.collection('cart').doc(currentUser!.uid).get();

        List<ProductModel> cartedItemsDetailsList = [];

        if (cartedIdsDocuments.exists) {
          for (final id in (cartedIdsDocuments['ids'] as List)) {
            final result = await fireStore.collection('products').doc(id).get();
            ProductModel product = ProductModel.fromDocument(result);

            if (product.status == ProductStatus.active.product) {
              cartedItemsDetailsList.add(
                ProductModel.fromDocument(result),
              );
            } else {
              removeProductFromCart(id);
            }
          }
        }

        return cartedItemsDetailsList;
      } on FirebaseException catch (e) {
        throw DBException(errorMessage: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> setCartDetailsToPurchaseHistoryAndDeleteCart(
      String price) async {
    try {
      final currentUser = auth.currentUser;
      try {
        final purchaseId = const Uuid().v4();

        final cartedProductIdsList = await getCartedItems();
        await fireStore
            .collection('purchase')
            .doc(currentUser!.uid)
            .collection('history')
            .doc(purchaseId)
            .set({
          'purchaseId': purchaseId,
          'date': DateTime.timestamp(),
          'price': price,
        });

        for (final productId in cartedProductIdsList) {
          await fireStore
              .collection('purchase')
              .doc(currentUser.uid)
              .collection('history')
              .doc(purchaseId)
              .update({
            'ids': FieldValue.arrayUnion([productId])
          });
        }

        await fireStore.collection('cart').doc(currentUser.uid).delete();

        return ResponseTypes.success.response;
      } on FirebaseException catch (e) {
        throw DBException(errorMessage: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    }
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/variable_names.dart';
import '../../../../core/utils/extension.dart';
import '../../../models/product/product_model.dart';
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

      final checkDocument = await fireStore
          .collection(AppVariableNames.cart)
          .doc(currentUser!.uid)
          .get();

      if (checkDocument.exists) {
        await fireStore
            .collection(AppVariableNames.cart)
            .doc(currentUser.uid)
            .update({
          'ids': FieldValue.arrayUnion([productId])
        });
      } else {
        await fireStore
            .collection(AppVariableNames.cart)
            .doc(currentUser.uid)
            .set({
          'ids': FieldValue.arrayUnion([productId])
        });
      }

      return ResponseTypes.success.response;
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<String>> getCartedItems() async {
    try {
      final currentUser = auth.currentUser;

      final result = await fireStore
          .collection(AppVariableNames.cart)
          .doc(currentUser!.uid)
          .get();

      if (result.exists) {
        return List<String>.from(
          (result.data()?['ids'] as List).map((e) => e),
        ).toList();
      } else {
        return [];
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String> removeProductFromCart(String productId) async {
    try {
      final currentUser = auth.currentUser;

      await fireStore
          .collection(AppVariableNames.cart)
          .doc(currentUser!.uid)
          .update({
        'ids': FieldValue.arrayRemove([productId])
      });

      return ResponseTypes.success.response;
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<ProductModel>> getAllCartedItemsDetailsById() async {
    try {
      final currentUser = auth.currentUser;

      final cartedIdsDocuments = await fireStore
          .collection(AppVariableNames.cart)
          .doc(currentUser!.uid)
          .get();

      final cartedData = cartedIdsDocuments.data();
      if (cartedData == null || cartedData['ids'] == null) return [];

      List<ProductModel> cartedItemsDetailsList = [];

      for (final id in (cartedData['ids'] as List)) {
        final result =
            await fireStore.collection(AppVariableNames.products).doc(id).get();

        if (result.data() == null) continue;

        ProductModel product = ProductModel.fromDocument(result);

        if (product.status == ProductStatus.active.product) {
          cartedItemsDetailsList.add(product);
        } else {
          try {
            await removeProductFromCart(id);
          } catch (e) {
            throw DBException(errorMessage: e.toString());
          }
        }
      }

      return cartedItemsDetailsList;
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String> setCartDetailsToPurchaseHistoryAndDeleteCart(
      String price) async {
    try {
      final currentUser = auth.currentUser;

      final purchaseId = const Uuid().v4();

      final cartedProductIdsList = await getCartedItems();

      CollectionReference purchaseCollection =
          fireStore.collection(AppVariableNames.purchase);

      await purchaseCollection
          .doc(currentUser!.uid)
          .set({"id": currentUser.uid});

      await purchaseCollection
          .doc(currentUser.uid)
          .collection(AppVariableNames.history)
          .doc(purchaseId)
          .set({
        'purchaseId': purchaseId,
        'date': DateTime.timestamp(),
        'price': price,
      });

      for (final productId in cartedProductIdsList) {
        await purchaseCollection
            .doc(currentUser.uid)
            .collection(AppVariableNames.history)
            .doc(purchaseId)
            .update({
          'ids': FieldValue.arrayUnion([productId])
        });
      }

      await fireStore
          .collection(AppVariableNames.cart)
          .doc(currentUser.uid)
          .delete();

      return ResponseTypes.success.response;
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace.toString());
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}

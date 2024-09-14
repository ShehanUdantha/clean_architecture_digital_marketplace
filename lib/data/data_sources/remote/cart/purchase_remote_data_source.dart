// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../../core/constants/variable_names.dart';
import '../../../../core/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/models/product/product_model.dart';
import '../../../../data/models/product/purchase_products_model.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';

abstract class PurchaseRemoteDataSource {
  Future<List<PurchaseProductsModel>> getAllPurchaseHistoryByUserId();
  Future<List<ProductModel>> getAllPurchaseItemsByProductId(
      List<String> productIds);
  Future<String> downloadProductByProductId(String productId);
}

class PurchaseRemoteDataSourceImpl implements PurchaseRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  PurchaseRemoteDataSourceImpl({
    required this.fireStore,
    required this.auth,
  });

  @override
  Future<List<PurchaseProductsModel>> getAllPurchaseHistoryByUserId() async {
    try {
      final currentUser = auth.currentUser;
      try {
        final result = await fireStore
            .collection(AppVariableNames.purchase)
            .doc(currentUser!.uid)
            .collection(AppVariableNames.history)
            .orderBy('date', descending: true)
            .get();

        return List<PurchaseProductsModel>.from(
            (result.docs).map((e) => PurchaseProductsModel.fromMap(e.data())));
      } on FirebaseException catch (e) {
        throw DBException(errorMessage: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getAllPurchaseItemsByProductId(
      List<String> productIds) async {
    try {
      final List<ProductModel> productList = [];

      for (final productId in productIds) {
        final result = await fireStore
            .collection(AppVariableNames.products)
            .doc(productId)
            .get();
        productList.add(ProductModel.fromDocument(result));
      }

      return productList;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> downloadProductByProductId(String productId) async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.products)
          .doc(productId)
          .get();

      ProductModel productModel = ProductModel.fromDocument(result);

      FileDownloader.downloadFile(url: productModel.zipFile);
      return ResponseTypes.success.response;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }
}

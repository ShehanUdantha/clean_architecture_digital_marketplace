// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../../core/constants/variable_names.dart';
import '../../../../core/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/product/product_model.dart';
import '../../../models/product/purchase_products_model.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';

abstract class PurchaseRemoteDataSource {
  Future<List<PurchaseProductsModel>> getAllPurchaseHistoryByUserId();
  Future<List<ProductModel>> getAllPurchaseItemsByItsProductIds(
      List<String> productIds);
  Future<String> downloadProductByProductId(String productId);
  Future<Map<String, int>> getAllPurchaseHistoryByMonth(
    int year,
    int month,
  );
  Future<double> getAllPurchasesTotalBalanceByMonth(
    int year,
    int month,
  );
  Future<double> getAllPurchasesTotalBalancePercentageByMonth(
    int year,
    int month,
  );
  Future<List<ProductModel>> getAllTopSellingProductsByMonth(
    int year,
    int month,
  );
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
  Future<List<ProductModel>> getAllPurchaseItemsByItsProductIds(
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

  @override
  Future<Map<String, int>> getAllPurchaseHistoryByMonth(
    int year,
    int month,
  ) async {
    try {
      // key is the day, value is the number of products
      Map<String, int> purchaseHistoryByMonth = {};

      DateTime startOfMonth = DateTime(year, month, 1);
      DateTime endOfMonth = DateTime(year, month + 1, 1);

      CollectionReference purchaseCollection =
          fireStore.collection(AppVariableNames.purchase);
      QuerySnapshot usersSnapshot = await purchaseCollection.get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        CollectionReference historyCollection = purchaseCollection
            .doc(userDoc.id)
            .collection(AppVariableNames.history);

        QuerySnapshot historySnapshot = await historyCollection
            .where('date', isGreaterThanOrEqualTo: startOfMonth)
            .where('date', isLessThan: endOfMonth)
            .get();

        for (QueryDocumentSnapshot purchaseDoc in historySnapshot.docs) {
          DateTime purchaseDate = (purchaseDoc['date'] as Timestamp).toDate();
          List<String> productIds = List<String>.from(purchaseDoc['ids']);

          String dayKey = purchaseDate.day.toString().padLeft(2, '0');

          if (purchaseHistoryByMonth.containsKey(dayKey)) {
            purchaseHistoryByMonth[dayKey] =
                purchaseHistoryByMonth[dayKey]! + productIds.length;
          } else {
            purchaseHistoryByMonth[dayKey] = productIds.length;
          }
        }
      }

      return purchaseHistoryByMonth;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<double> getAllPurchasesTotalBalanceByMonth(
    int year,
    int month,
  ) async {
    try {
      double balance = 0.00;

      DateTime startOfMonth = DateTime(year, month, 1);
      DateTime endOfMonth = DateTime(year, month + 1, 1);

      CollectionReference purchaseCollection =
          fireStore.collection(AppVariableNames.purchase);
      QuerySnapshot usersSnapshot = await purchaseCollection.get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        CollectionReference historyCollection = purchaseCollection
            .doc(userDoc.id)
            .collection(AppVariableNames.history);

        QuerySnapshot historySnapshot = await historyCollection
            .where('date', isGreaterThanOrEqualTo: startOfMonth)
            .where('date', isLessThan: endOfMonth)
            .get();

        for (QueryDocumentSnapshot purchaseDoc in historySnapshot.docs) {
          double price = double.tryParse(purchaseDoc['price']) ?? 0;

          balance = balance + price;
        }
      }

      return balance;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<double> getAllPurchasesTotalBalancePercentageByMonth(
    int year,
    int month,
  ) async {
    try {
      double percentage = 0.00;

      final double thisMonthBalance = await getAllPurchasesTotalBalanceByMonth(
        year,
        month,
      );

      final double lastMonthBalance = await getAllPurchasesTotalBalanceByMonth(
        month == 1 ? year - 1 : year,
        month == 1 ? 12 : month - 1,
      );

      if (lastMonthBalance > 0) {
        percentage =
            ((thisMonthBalance - lastMonthBalance) / lastMonthBalance) * 100;
      } else {
        percentage = thisMonthBalance > 0 ? 100 : 0.0;
      }

      return percentage;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getAllTopSellingProductsByMonth(
    int year,
    int month,
  ) async {
    try {
      List<ProductModel> topSellingProducts = [];
      Map<String, int> productCountMap = {};

      DateTime startOfMonth = DateTime(year, month, 1);
      DateTime endOfMonth = DateTime(year, month + 1, 1);

      CollectionReference purchaseCollection =
          fireStore.collection(AppVariableNames.purchase);
      QuerySnapshot usersSnapshot = await purchaseCollection.get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        CollectionReference historyCollection = purchaseCollection
            .doc(userDoc.id)
            .collection(AppVariableNames.history);

        QuerySnapshot historySnapshot = await historyCollection
            .where('date', isGreaterThanOrEqualTo: startOfMonth)
            .where('date', isLessThan: endOfMonth)
            .get();

        for (QueryDocumentSnapshot purchaseDoc in historySnapshot.docs) {
          List<String> productIds = List<String>.from(purchaseDoc['ids']);

          for (String productId in productIds) {
            if (productCountMap.containsKey(productId)) {
              productCountMap[productId] = productCountMap[productId]! + 1;
            } else {
              productCountMap[productId] = 1;
            }
          }
        }
      }

      List<MapEntry<String, int>> sortedProductCounts = productCountMap.entries
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (MapEntry<String, int> entry in sortedProductCounts) {
        String productId = entry.key;

        final result = await fireStore
            .collection(AppVariableNames.products)
            .doc(productId)
            .get();

        if (result.exists) {
          ProductModel product = ProductModel.fromDocument(result);
          topSellingProducts.add(product);
        }
      }

      return topSellingProducts;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }
}

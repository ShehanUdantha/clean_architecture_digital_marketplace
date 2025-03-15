// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/data/models/user/user_model.dart';

import '../../../../core/constants/variable_names.dart';
import '../../../../core/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/usecases/cart/purchase/year_and_month_params.dart';
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
      YearAndMonthParams yearAndMonthParams);
  Future<double> getAllPurchasesTotalBalanceByMonth(
      YearAndMonthParams yearAndMonthParams);
  Future<double> getAllPurchasesTotalBalancePercentageByMonth(
      YearAndMonthParams yearAndMonthParams);
  Future<List<ProductModel>> getAllTopSellingProductsByMonth(
      YearAndMonthParams yearAndMonthParams);
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

      final result = await fireStore
          .collection(AppVariableNames.purchase)
          .doc(currentUser!.uid)
          .collection(AppVariableNames.history)
          .orderBy('date', descending: true)
          .get();

      return List<PurchaseProductsModel>.from(
          (result.docs).map((e) => PurchaseProductsModel.fromMap(e.data())));
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
  Future<String> downloadProductByProductId(String productId) async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.products)
          .doc(productId)
          .get();

      ProductModel productModel = ProductModel.fromDocument(result);

      FileDownloader.downloadFile(url: productModel.zipFile);
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
  Future<Map<String, int>> getAllPurchaseHistoryByMonth(
      YearAndMonthParams yearAndMonthParams) async {
    try {
      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(yearAndMonthParams.userId)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext!.loc.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        // key is the day, value is the number of products
        Map<String, int> purchaseHistoryByMonth = {};

        DateTime startOfMonth =
            DateTime(yearAndMonthParams.year, yearAndMonthParams.month, 1);
        DateTime endOfMonth =
            DateTime(yearAndMonthParams.year, yearAndMonthParams.month + 1, 1);

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
      } else {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext!.loc.unauthorizedAccess,
        );
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
  Future<double> getAllPurchasesTotalBalanceByMonth(
      YearAndMonthParams yearAndMonthParams) async {
    try {
      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(yearAndMonthParams.userId)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext!.loc.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        double balance = 0.00;

        DateTime startOfMonth =
            DateTime(yearAndMonthParams.year, yearAndMonthParams.month, 1);
        DateTime endOfMonth =
            DateTime(yearAndMonthParams.year, yearAndMonthParams.month + 1, 1);

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
      } else {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext!.loc.unauthorizedAccess,
        );
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
  Future<double> getAllPurchasesTotalBalancePercentageByMonth(
      YearAndMonthParams yearAndMonthParams) async {
    try {
      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(yearAndMonthParams.userId)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext!.loc.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        double percentage = 0.00;

        final double thisMonthBalance =
            await getAllPurchasesTotalBalanceByMonth(yearAndMonthParams);

        final yearAndMonthParamsForLatMonth = YearAndMonthParams(
          year: yearAndMonthParams.month == 1
              ? yearAndMonthParams.year - 1
              : yearAndMonthParams.year,
          month:
              yearAndMonthParams.month == 1 ? 12 : yearAndMonthParams.month - 1,
          userId: yearAndMonthParams.userId,
        );

        final double lastMonthBalance =
            await getAllPurchasesTotalBalanceByMonth(
                yearAndMonthParamsForLatMonth);

        if (lastMonthBalance > 0 && thisMonthBalance > 0) {
          percentage =
              ((thisMonthBalance - lastMonthBalance) / lastMonthBalance) * 100;
        } else if (lastMonthBalance <= 0 && thisMonthBalance > 0) {
          percentage = 100;
        } else if (lastMonthBalance > 0 && thisMonthBalance <= 0) {
          percentage = -100;
        }

        return percentage;
      } else {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext!.loc.unauthorizedAccess,
        );
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
  Future<List<ProductModel>> getAllTopSellingProductsByMonth(
      YearAndMonthParams yearAndMonthParams) async {
    try {
      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(yearAndMonthParams.userId)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext!.loc.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        List<ProductModel> topSellingProducts = [];
        Map<String, int> productCountMap = {};

        DateTime startOfMonth =
            DateTime(yearAndMonthParams.year, yearAndMonthParams.month, 1);
        DateTime endOfMonth =
            DateTime(yearAndMonthParams.year, yearAndMonthParams.month + 1, 1);

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

        List<MapEntry<String, int>> sortedProductCounts =
            productCountMap.entries.toList()
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
      } else {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext!.loc.unauthorizedAccess,
        );
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
}

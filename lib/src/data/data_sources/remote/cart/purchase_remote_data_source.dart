// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/data/models/user/user_model.dart';
import 'package:Pixelcart/src/domain/entities/cart/purchase_entity.dart';

import '../../../../core/constants/variable_names.dart';
import '../../../../core/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/usecases/cart/purchase/year_and_month_params.dart';
import '../../../models/product/product_model.dart';
import '../../../models/cart/purchase_model.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';

abstract class PurchaseRemoteDataSource {
  Future<List<PurchaseModel>> getAllPurchaseHistoryByUserId();
  Future<List<ProductModel>> getAllPurchaseItemsByItsProductIds(
      PurchaseEntity purchaseDetails);
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
  Future<List<PurchaseModel>> getAllPurchaseHistoryByUserId() async {
    try {
      final currentUser = auth.currentUser;

      final result = await fireStore
          .collection(AppVariableNames.purchase)
          .doc(currentUser!.uid)
          .collection(AppVariableNames.history)
          .orderBy('date', descending: true)
          .get();

      return List<PurchaseModel>.from(
          (result.docs).map((e) => PurchaseModel.fromMap(e.data())));
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
      PurchaseEntity purchaseDetails) async {
    try {
      final currentUser = auth.currentUser;

      final List<ProductModel> productList = [];

      final result = await fireStore
          .collection(AppVariableNames.purchase)
          .doc(currentUser!.uid)
          .collection(AppVariableNames.history)
          .doc(purchaseDetails.purchaseId)
          .get();

      if (!result.exists) {
        throw DBException(
            errorMessage:
                rootNavigatorKey.currentContext?.loc.purchaseHistoryNotFound ??
                    AppErrorMessages.purchaseHistoryNotFound);
      }

      final historyProducts =
          Set<String>.from(PurchaseModel.fromDocument(result).products);

      if (!historyProducts.containsAll(purchaseDetails.products)) {
        throw DBException(
            errorMessage: rootNavigatorKey
                    .currentContext?.loc.purchaseHistoryNotFound ??
                AppErrorMessages.productListDoesNotMatchWithPurchaseHistory);
      }

      for (final productId in purchaseDetails.products) {
        final productResult = await fireStore
            .collection(AppVariableNames.products)
            .doc(productId)
            .get();

        if (productResult.exists) {
          final product = ProductModel.fromDocument(productResult);

          // Fetch zip file from sub collection
          final zipDoc = await fireStore
              .collection(AppVariableNames.products)
              .doc(product.id)
              .collection(AppVariableNames.productData)
              .doc('files')
              .get();

          if (zipDoc.exists) {
            final zipData = zipDoc.data();

            ProductModel modifiedProductModel = ProductModel(
              id: product.id,
              productName: product.productName,
              price: product.price,
              category: product.category,
              marketingType: product.marketingType,
              description: product.description,
              coverImage: product.coverImage,
              subImages: product.subImages,
              dateCreated: product.dateCreated,
              likes: product.likes,
              status: product.status,
              zipFile: zipData?['zipFile'],
            );

            productList.add(modifiedProductModel);
          } else {
            productList.add(product);
          }
        }
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
  Future<Map<String, int>> getAllPurchaseHistoryByMonth(
      YearAndMonthParams yearAndMonthParams) async {
    try {
      final currentUser = auth.currentUser;

      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext?.loc.userNotFound ??
                AppErrorMessages.userNotFound);
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

        final QuerySnapshot usersSnapshot =
            await fireStore.collection(AppVariableNames.purchase).get();

        for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
          QuerySnapshot historySnapshot = await fireStore
              .collection(AppVariableNames.purchase)
              .doc(userDoc.id)
              .collection(AppVariableNames.history)
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
          errorMessage:
              rootNavigatorKey.currentContext?.loc.unauthorizedAccess ??
                  AppErrorMessages.unauthorizedAccess,
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
      final currentUser = auth.currentUser;

      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext?.loc.userNotFound ??
                AppErrorMessages.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        double balance = 0.00;

        DateTime startOfMonth =
            DateTime(yearAndMonthParams.year, yearAndMonthParams.month, 1);
        DateTime endOfMonth =
            DateTime(yearAndMonthParams.year, yearAndMonthParams.month + 1, 1);

        final QuerySnapshot usersSnapshot =
            await fireStore.collection(AppVariableNames.purchase).get();

        for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
          QuerySnapshot historySnapshot = await fireStore
              .collection(AppVariableNames.purchase)
              .doc(userDoc.id)
              .collection(AppVariableNames.history)
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
          errorMessage:
              rootNavigatorKey.currentContext?.loc.unauthorizedAccess ??
                  AppErrorMessages.unauthorizedAccess,
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
      final currentUser = auth.currentUser;

      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext?.loc.userNotFound ??
                AppErrorMessages.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        double percentage = 0.00;

        final double selectedMonthBalance =
            await getAllPurchasesTotalBalanceByMonth(yearAndMonthParams);

        final yearAndMonthParamsForLatMonth = YearAndMonthParams(
          year: yearAndMonthParams.month == 1
              ? yearAndMonthParams.year - 1
              : yearAndMonthParams.year,
          month:
              yearAndMonthParams.month == 1 ? 12 : yearAndMonthParams.month - 1,
        );

        final double lastMonthBalance =
            await getAllPurchasesTotalBalanceByMonth(
                yearAndMonthParamsForLatMonth);

        if (lastMonthBalance > 0 && selectedMonthBalance > 0) {
          percentage =
              ((selectedMonthBalance - lastMonthBalance) / lastMonthBalance) *
                  100;
        } else if (lastMonthBalance <= 0 && selectedMonthBalance > 0) {
          percentage = 100;
        } else if (lastMonthBalance > 0 && selectedMonthBalance <= 0) {
          percentage = -100;
        }

        return percentage;
      } else {
        throw AuthException(
          errorMessage:
              rootNavigatorKey.currentContext?.loc.unauthorizedAccess ??
                  AppErrorMessages.unauthorizedAccess,
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
      final currentUser = auth.currentUser;

      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext?.loc.userNotFound ??
                AppErrorMessages.userNotFound);
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

        final QuerySnapshot usersSnapshot =
            await fireStore.collection(AppVariableNames.purchase).get();

        for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
          QuerySnapshot historySnapshot = await fireStore
              .collection(AppVariableNames.purchase)
              .doc(userDoc.id)
              .collection(AppVariableNames.history)
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
          errorMessage:
              rootNavigatorKey.currentContext?.loc.unauthorizedAccess ??
                  AppErrorMessages.unauthorizedAccess,
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

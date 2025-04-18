import '../../../../core/constants/error_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/routes/router.dart';
import '../../../../core/constants/variable_names.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/extension.dart';
import '../../../models/category/category_model.dart';
import '../../../models/user/user_model.dart';

abstract class CategoryRemoteDataSource {
  Future<String> addCategory(String categoryName);
  Future<List<CategoryModel>> getAllCategories();
  Future<String> deleteCategory(String categoryId);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  CategoryRemoteDataSourceImpl({
    required this.fireStore,
    required this.auth,
  });

  @override
  Future<String> addCategory(String categoryName) async {
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
        final result = await fireStore
            .collection(AppVariableNames.categories)
            .where('name', isEqualTo: categoryName)
            .get();

        if (result.docs.isEmpty) {
          final String categoryId = const Uuid().v1();

          CategoryModel categoryModel = CategoryModel(
            id: categoryId,
            name: categoryName,
            dateCreated: DateTime.now(),
          );
          await fireStore
              .collection(AppVariableNames.categories)
              .doc(categoryId)
              .set(categoryModel.toJson());

          return ResponseTypes.success.response;
        } else {
          return ResponseTypes.failure.response;
        }
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
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.categories)
          .orderBy('dateCreated', descending: true)
          .get();

      return List<CategoryModel>.from(
          (result.docs).map((e) => CategoryModel.fromMap(e)));
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
  Future<String> deleteCategory(String categoryId) async {
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
        await fireStore
            .collection(AppVariableNames.categories)
            .doc(categoryId)
            .delete();

        return ResponseTypes.success.response;
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

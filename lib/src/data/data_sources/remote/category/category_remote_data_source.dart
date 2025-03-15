import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/routes/router.dart';
import '../../../../core/constants/variable_names.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/extension.dart';
import '../../../../domain/usecases/category/add_category_params.dart';
import '../../../../domain/usecases/category/delete_category_params.dart';
import '../../../models/category/category_model.dart';
import '../../../models/user/user_model.dart';

abstract class CategoryRemoteDataSource {
  Future<String> addCategory(AddCategoryParams addCategoryParams);
  Future<List<CategoryModel>> getAllCategories();
  Future<String> deleteCategory(DeleteCategoryParams deleteCategoryParams);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore fireStore;

  CategoryRemoteDataSourceImpl({
    required this.fireStore,
  });

  @override
  Future<String> addCategory(AddCategoryParams addCategoryParams) async {
    try {
      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(addCategoryParams.userId)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext!.loc.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        final result = await fireStore
            .collection(AppVariableNames.categories)
            .where('name', isEqualTo: addCategoryParams.name)
            .get();

        if (result.docs.isEmpty) {
          final String categoryId = const Uuid().v1();

          CategoryModel categoryModel = CategoryModel(
            id: categoryId,
            name: addCategoryParams.name,
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
  Future<String> deleteCategory(
      DeleteCategoryParams deleteCategoryParams) async {
    try {
      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(deleteCategoryParams.userId)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext!.loc.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        await fireStore
            .collection(AppVariableNames.categories)
            .doc(deleteCategoryParams.categoryId)
            .delete();

        return ResponseTypes.success.response;
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

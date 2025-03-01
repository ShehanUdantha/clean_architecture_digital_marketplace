import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/variable_names.dart';
import '../../../../core/utils/extension.dart';

import '../../../../core/utils/enum.dart';
import '../../../models/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exception.dart';

abstract class CategoryRemoteDataSource {
  Future<String> addCategory(String name);
  Future<List<CategoryModel>> getAllCategories();
  Future<String> deleteCategory(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore fireStore;

  CategoryRemoteDataSourceImpl({
    required this.fireStore,
  });

  @override
  Future<String> addCategory(String name) async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.categories)
          .where('name', isEqualTo: name)
          .get();

      if (result.docs.isEmpty) {
        final String categoryId = const Uuid().v1();

        CategoryModel categoryModel = CategoryModel(
          id: categoryId,
          name: name,
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
  Future<String> deleteCategory(String id) async {
    try {
      await fireStore.collection(AppVariableNames.categories).doc(id).delete();

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
}

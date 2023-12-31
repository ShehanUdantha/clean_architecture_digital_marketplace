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
          .collection('categories')
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
            .collection('categories')
            .doc(categoryId)
            .set(categoryModel.toJson());

        return ResponseTypes.success.response;
      } else {
        return ResponseTypes.failure.response;
      }
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final result = await fireStore
          .collection('categories')
          .orderBy('dateCreated', descending: true)
          .get();

      return List<CategoryModel>.from(
          (result.docs).map((e) => CategoryModel.fromMap(e)));
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> deleteCategory(String id) async {
    try {
      await fireStore.collection('categories').doc(id).delete();

      return ResponseTypes.success.response;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }
}

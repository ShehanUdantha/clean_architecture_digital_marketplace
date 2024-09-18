// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/variable_names.dart';
import '../../../../core/utils/extension.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';
import '../../../../domain/entities/product/product_entity.dart';
import '../../../models/product/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<String> addProduct(ProductEntity productEntity);
  Future<List<ProductModel>> getAllProducts(String category);
  Future<String> deleteProduct(String productId);
  Future<List<ProductModel>> getProductByMarketingTypes(String marketingType);
  Future<List<ProductModel>> getProductByQuery(String query);
  Future<ProductModel> getProductDetailsById(String productId);
  Future<ProductModel> addFavorite(String productId);
  Future<String> editProduct(ProductEntity productEntity);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  ProductRemoteDataSourceImpl({
    required this.fireStore,
    required this.auth,
    required this.storage,
  });

  @override
  Future<String> addProduct(ProductEntity productEntity) async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.products)
          .where('productName', isEqualTo: productEntity.productName)
          .get();

      if (result.docs.isEmpty) {
        final String productId = const Uuid().v1();

        final String coverImageUrl = await uploadImage(
          productEntity.coverImage,
          productId,
        );

        final String zipFileUrl = await uploadFile(
          productEntity.zipFile,
          productId,
        );

        final List<String> subImagesUrls = await uploadMultipleImages(
          productEntity.subImages,
          productId,
        );

        ProductModel productModel = ProductModel(
          id: productId,
          productName: productEntity.productName,
          price: productEntity.price,
          category: productEntity.category,
          marketingType: productEntity.marketingType,
          description: productEntity.description,
          coverImage: coverImageUrl,
          subImages: subImagesUrls,
          zipFile: zipFileUrl,
          dateCreated: DateTime.now(),
          likes: const [],
          status: ProductStatus.active.product,
        );

        await fireStore
            .collection(AppVariableNames.products)
            .doc(productId)
            .set(productModel.toJson());

        return ResponseTypes.success.response;
      } else {
        return ResponseTypes.failure.response;
      }
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  Future<List<String>> uploadMultipleImages(
    List<Uint8List> images,
    String id,
  ) async {
    var imageUrls = await Future.wait(
      images.map((image) {
        return uploadImage(image, id);
      }),
    );
    return imageUrls;
  }

  Future<String> uploadImage(
    Uint8List file,
    String productId,
  ) async {
    Reference reference = storage
        .ref()
        .child('product')
        .child(productId)
        .child(const Uuid().v4());

    // image uploaded and store
    UploadTask task = reference.putData(file);
    TaskSnapshot snapshot = await task;
    // get downloadable url from stored image
    String downloadableUrl = await snapshot.ref.getDownloadURL();

    return downloadableUrl;
  }

  Future<String> uploadFile(
    File file,
    String productId,
  ) async {
    Reference reference =
        storage.ref().child('product').child(productId).child(file.path);

    // file uploaded and store
    UploadTask task = reference.putFile(file);
    TaskSnapshot snapshot = await task;
    // get downloadable url from stored file
    String downloadableUrl = await snapshot.ref.getDownloadURL();

    return downloadableUrl;
  }

  @override
  Future<List<ProductModel>> getAllProducts(String category) async {
    try {
      final result = category != 'All Items'
          ? await fireStore
              .collection(AppVariableNames.products)
              .where('category', isEqualTo: category)
              .where('status', isEqualTo: ProductStatus.active.product)
              .get()
          : await fireStore
              .collection(AppVariableNames.products)
              .where('status', isEqualTo: ProductStatus.active.product)
              .get();

      return List<ProductModel>.from(
          (result.docs).map((e) => ProductModel.fromMap(e)));
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> deleteProduct(String productId) async {
    try {
      await fireStore
          .collection(AppVariableNames.products)
          .doc(productId)
          .update({
        'status': ProductStatus.deActive.product,
      });

      return ResponseTypes.success.response;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProductByMarketingTypes(
      String marketingType) async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.products)
          .where('marketingType', isEqualTo: marketingType)
          .where('status', isEqualTo: ProductStatus.active.product)
          .get();

      return List<ProductModel>.from(
          (result.docs).map((e) => ProductModel.fromMap(e)));
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProductByQuery(String query) async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.products)
          .where('productName', isGreaterThanOrEqualTo: query)
          .where('productName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      if (result.docs.isEmpty) {
        return [];
      }

      return List<ProductModel>.from(
        result.docs
            .map((e) => ProductModel.fromMap(e))
            .where((product) => product.status == ProductStatus.active.product),
      );
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<ProductModel> getProductDetailsById(String productId) async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.products)
          .doc(productId)
          .get();

      return ProductModel.fromDocument(result);
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<ProductModel> addFavorite(String productId) async {
    try {
      final currentUser = auth.currentUser;
      try {
        final result = await fireStore
            .collection(AppVariableNames.products)
            .doc(productId)
            .get();

        final product = ProductModel.fromDocument(result);

        if (product.likes.contains(currentUser!.uid)) {
          await fireStore
              .collection(AppVariableNames.products)
              .doc(productId)
              .update({
            'likes': FieldValue.arrayRemove([currentUser.uid]),
          });

          final result = await fireStore
              .collection(AppVariableNames.products)
              .doc(productId)
              .get();

          return ProductModel.fromDocument(result);
        } else {
          await fireStore
              .collection(AppVariableNames.products)
              .doc(productId)
              .update({
            'likes': FieldValue.arrayUnion([currentUser.uid]),
          });

          final result = await fireStore
              .collection(AppVariableNames.products)
              .doc(productId)
              .get();

          return ProductModel.fromDocument(result);
        }
      } on FirebaseException catch (e) {
        throw DBException(errorMessage: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> editProduct(ProductEntity productEntity) async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.products)
          .doc(productEntity.id)
          .get();

      if (result.exists) {
        final productId = productEntity.id!;

        final String coverImageUrl = await getCoverImageUrl(productEntity);
        final String zipFileUrl = await getZipFileUrl(productEntity);
        final List<String> subImagesUrls =
            await getSubImagesUrls(productEntity);

        await fireStore
            .collection(AppVariableNames.products)
            .doc(productId)
            .update({
          "productName": productEntity.productName,
          "price": productEntity.price,
          "category": productEntity.category,
          "marketingType": productEntity.marketingType,
          "description": productEntity.description,
          "coverImage": coverImageUrl,
          "subImages": subImagesUrls,
          "zipFile": zipFileUrl,
        });

        return ResponseTypes.success.response;
      } else {
        return ResponseTypes.failure.response;
      }
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  Future<String> getCoverImageUrl(ProductEntity productEntity) async {
    return productEntity.coverImage is Uint8List
        ? await uploadImage(productEntity.coverImage, productEntity.id ?? "")
        : productEntity.coverImage;
  }

  Future<String> getZipFileUrl(ProductEntity productEntity) async {
    return productEntity.zipFile is File
        ? await uploadFile(productEntity.zipFile, productEntity.id ?? "")
        : productEntity.zipFile;
  }

  Future<List<String>> getSubImagesUrls(ProductEntity productEntity) async {
    final tempSubImagesUrls = productEntity.subImages != null
        ? await uploadMultipleImages(
            productEntity.subImages, productEntity.id ?? "")
        : [];

    return [...tempSubImagesUrls, ...productEntity.sharedSubImages ?? []];
  }
}

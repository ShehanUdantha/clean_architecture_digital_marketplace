import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/product/product_remote_data_source.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/auth_values.dart';
import '../../../../fixtures/category_values.dart';
import '../../../../fixtures/product_values.dart';
import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Query,
  User
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late MockFirebaseStorage mockFirebaseStorage;
  late ProductRemoteDataSource productRemoteDataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    mockFirebaseStorage = MockFirebaseStorage();

    productRemoteDataSource = ProductRemoteDataSourceImpl(
      auth: mockFirebaseAuth,
      fireStore: fakeFirebaseFirestore,
      storage: mockFirebaseStorage,
    );
  });

  group(
    'addProduct',
    () {
      test(
        'should return a Success Status when adding a product to products list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Act
          final result =
              await productRemoteDataSource.addProduct(newProductEntity);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should return a Failure Status when adding an already exist product to products list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(newProductModel.id)
              .set(newProductModel.toJson());

          // Act
          final result =
              await productRemoteDataSource.addProduct(newProductEntity);

          // Assert
          expect(result, ResponseTypes.failure.response);
        },
      );

      test(
        'should throw AuthException when the user is not found',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.addProduct(newProductEntity),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.userNotFound,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException when a non-admin user attempts to add product to the products list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.addProduct(newProductEntity),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.unauthorizedAccess,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if an error occurs while adding a product to products list',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.currentUser,
          ).thenThrow(
            FirebaseAuthException(
              code: 'unknown',
              message: AppErrorMessages.authenticationErrorOccurred,
            ),
          );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.addProduct(newProductEntity),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                '[firebase_auth/unknown] ${AppErrorMessages.authenticationErrorOccurred}',
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException when a database operation fails while adding a product to products list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          final mockFirestore = MockFirebaseFirestore();
          final DocumentReference<Map<String, dynamic>> mockUserDocRef =
              MockDocumentReference();
          final DocumentSnapshot<Map<String, dynamic>> mockUserDocSnapshot =
              MockDocumentSnapshot();
          final CollectionReference<Map<String, dynamic>> mockUserCollection =
              MockCollectionReference();
          final CollectionReference<Map<String, dynamic>>
              mockProductsCollection = MockCollectionReference();
          final Query<Map<String, dynamic>> mockProductsQuery = MockQuery();

          when(mockFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollection);
          when(mockUserCollection.doc(userAdminId)).thenReturn(mockUserDocRef);
          when(mockUserDocRef.get())
              .thenAnswer((_) async => mockUserDocSnapshot);
          when(mockUserDocSnapshot.exists).thenReturn(true);
          when(mockUserDocSnapshot.data()).thenReturn(userAdminModel.toJson());

          when(mockFirestore.collection(AppVariableNames.products))
              .thenReturn(mockProductsCollection);
          when(mockProductsCollection.where('productName',
                  isEqualTo: newProductEntity.productName))
              .thenReturn(mockProductsQuery);

          when(mockProductsQuery.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Add product failed',
            ),
          );

          final productRemoteDataSource = ProductRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
            storage: mockFirebaseStorage,
          );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.addProduct(newProductEntity),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Add product failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllProducts',
    () {
      test(
        'should return an All type of products when fetching all products data (All Items) (user type - Admin)',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add products to FakeFirestore
          for (final model in productsModelsWithZipFiles) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set({
              'id': model.id,
              'productName': model.productName,
              'price': model.price,
              'category': model.category,
              'marketingType': model.marketingType,
              'description': model.description,
              'coverImage': model.coverImage,
              'subImages': model.subImages,
              'dateCreated': model.dateCreated,
              'likes': model.likes,
              'status': model.status,
            });

            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .collection(AppVariableNames.productData)
                .doc('files')
                .set({'zipFile': model.zipFile});
          }

          // Act
          final result =
              await productRemoteDataSource.getAllProducts(categoryTypeForAll);

          // Assert
          expect(result, productsModelsWithZipFiles);
        },
      );

      test(
        'should return an All type of products when fetching all products data (All Items) (user type - User)',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          // Add products to FakeFirestore
          for (final model in productsModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result =
              await productRemoteDataSource.getAllProducts(categoryTypeForAll);

          // Assert
          expect(result, productsModels);
        },
      );

      test(
        'should return only specific products when fetching products by user-selected category (user type - Admin)',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Add products to FakeFirestore
          for (final model in fontsCategoryProductModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set({
              'id': model.id,
              'productName': model.productName,
              'price': model.price,
              'category': model.category,
              'marketingType': model.marketingType,
              'description': model.description,
              'coverImage': model.coverImage,
              'subImages': model.subImages,
              'dateCreated': model.dateCreated,
              'likes': model.likes,
              'status': model.status,
            });

            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .collection(AppVariableNames.productData)
                .doc('files')
                .set({'zipFile': model.zipFile});
          }

          // Act
          final result =
              await productRemoteDataSource.getAllProducts(categoryTypeFont);

          // Assert
          expect(result, fontsCategoryProductModels);
        },
      );

      test(
        'should return only specific products when fetching products by user-selected category (user type - User)',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          // Add products to FakeFirestore
          for (final model in fontsCategoryProductModelsWithoutZipFiles) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result =
              await productRemoteDataSource.getAllProducts(categoryTypeFont);

          // Assert
          expect(result, fontsCategoryProductModelsWithoutZipFiles);
        },
      );

      test(
        'should throw AuthException when the user is not found',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.getAllProducts(categoryTypeForAll),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.userNotFound,
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException when a database operation fails while fetching products data',
        () async {
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          final mockFirestore = MockFirebaseFirestore();
          final DocumentReference<Map<String, dynamic>> mockUserDocRef =
              MockDocumentReference();
          final DocumentSnapshot<Map<String, dynamic>> mockUserDocSnapshot =
              MockDocumentSnapshot();
          final CollectionReference<Map<String, dynamic>> mockUserCollection =
              MockCollectionReference();
          final CollectionReference<Map<String, dynamic>>
              mockProductsCollection = MockCollectionReference();
          final Query<Map<String, dynamic>> mockProductsQuery = MockQuery();

          when(mockFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollection);
          when(mockUserCollection.doc(userAdminId)).thenReturn(mockUserDocRef);
          when(mockUserDocRef.get())
              .thenAnswer((_) async => mockUserDocSnapshot);
          when(mockUserDocSnapshot.exists).thenReturn(true);
          when(mockUserDocSnapshot.data()).thenReturn(userAdminModel.toJson());

          when(mockFirestore.collection(AppVariableNames.products))
              .thenReturn(mockProductsCollection);
          when(mockProductsCollection.where('status',
                  isEqualTo: ProductStatus.active.product))
              .thenReturn(mockProductsQuery);

          when(mockProductsQuery.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Get all products failed',
            ),
          );

          final productRemoteDataSource = ProductRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
            storage: mockFirebaseStorage,
          );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.getAllProducts(categoryTypeForAll),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get all products failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'deleteProduct',
    () {
      test(
        'should return a Success Status when deleting a product from the product list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(newProductModel.id)
              .set(newProductModel.toJson());

          // Act
          final result =
              await productRemoteDataSource.deleteProduct(newProductModel.id!);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should throw AuthException when the user is not found',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.deleteProduct(newProductModel.id!),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.userNotFound,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException when a non-admin user attempts to delete the product from the product list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.deleteProduct(newProductModel.id!),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.unauthorizedAccess,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if an error occurs while deleting a product from the product list',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.currentUser,
          ).thenThrow(
            FirebaseAuthException(
              code: 'unknown',
              message: AppErrorMessages.authenticationErrorOccurred,
            ),
          );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.deleteProduct(newProductModel.id!),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                '[firebase_auth/unknown] ${AppErrorMessages.authenticationErrorOccurred}',
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException when a database operation fails while deleting a product from the product list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(newProductModel.id)
              .set(newProductModel.toJson());

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(newProductModel.id);

          whenCalling(Invocation.method(#update, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Delete product failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.deleteProduct(newProductModel.id!),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Delete product failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getProductByMarketingTypes',
    () {
      test(
        'should return a List of products when fetching products data by marketing type (Featured)',
        () async {
          // Arrange
          // Add products to FakeFirestore
          for (final model in productsModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result = await productRemoteDataSource
              .getProductByMarketingTypes(marketingTypeFeatured);

          // Assert
          expect(result, featuredMarketingTypeProducts);
        },
      );

      test(
        'should return a List of products when fetching products data by marketing type (Trending)',
        () async {
          // Arrange
          // Add products to FakeFirestore
          for (final model in productsModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result = await productRemoteDataSource
              .getProductByMarketingTypes(marketingTypeTrending);

          // Assert
          expect(result, trendingMarketingTypeProductModels);
        },
      );

      test(
        'should return a List of products when fetching products data by marketing type (Latest)',
        () async {
          // Arrange
          // Add products to FakeFirestore
          for (final model in productsModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result = await productRemoteDataSource
              .getProductByMarketingTypes(marketingTypeLatest);

          // Assert
          expect(result, latestMarketingTypeProductModel);
        },
      );

      test(
        'should throw DBException when a database operation fails while fetching products data by marketing type',
        () async {
          // Arrange
          final mockFirestore = MockFirebaseFirestore();

          final CollectionReference<Map<String, dynamic>>
              mockProductsCollection = MockCollectionReference();
          final Query<Map<String, dynamic>> mockProductsQuery = MockQuery();
          final Query<Map<String, dynamic>> mockProductsQuerySecond =
              MockQuery();

          when(mockFirestore.collection(AppVariableNames.products))
              .thenReturn(mockProductsCollection);
          when(mockProductsCollection.where('marketingType',
                  isEqualTo: marketingTypeFeatured))
              .thenReturn(mockProductsQuery);
          when(mockProductsQuery.where('status',
                  isEqualTo: ProductStatus.active.product))
              .thenReturn(mockProductsQuerySecond);

          when(mockProductsQuerySecond.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Get products by marketing type failed',
            ),
          );

          final productRemoteDataSource = ProductRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
            storage: mockFirebaseStorage,
          );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource
                .getProductByMarketingTypes(marketingTypeFeatured),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get products by marketing type failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getProductByQuery',
    () {
      test(
        'should return a List of products when fetching products data by user search using product name',
        () async {
          // Arrange
          // Add products to FakeFirestore
          for (final model in productsModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result = await productRemoteDataSource
              .getProductByQuery(productSearchQuery);

          // Assert
          expect(result, searchQueryResultProductModels);
        },
      );

      test(
        'should return an Empty List when the user search products does not exist',
        () async {
          // Arrange
          // Add products to FakeFirestore
          for (final model in productsModelsWithZipFiles) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result = await productRemoteDataSource
              .getProductByMarketingTypes(productSearchQueryTwo);

          // Assert
          expect(result, []);
        },
      );

      test(
        'should throw DBException when a database operation fails while fetching products data by user search using product name',
        () async {
          // Arrange
          final mockFirestore = MockFirebaseFirestore();

          final CollectionReference<Map<String, dynamic>>
              mockProductsCollection = MockCollectionReference();
          final Query<Map<String, dynamic>> mockProductsQuery = MockQuery();
          final Query<Map<String, dynamic>> mockProductsQuerySecond =
              MockQuery();

          when(mockFirestore.collection(AppVariableNames.products))
              .thenReturn(mockProductsCollection);
          when(mockProductsCollection.where('productName',
                  isGreaterThanOrEqualTo: productSearchQuery))
              .thenReturn(mockProductsQuery);
          when(mockProductsQuery.where('productName',
                  isLessThanOrEqualTo: '$productSearchQuery\uf8ff'))
              .thenReturn(mockProductsQuerySecond);

          when(mockProductsQuerySecond.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Get products by user search query failed',
            ),
          );

          final productRemoteDataSource = ProductRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
            storage: mockFirebaseStorage,
          );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.getProductByQuery(productSearchQuery),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get products by user search query failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getProductDetailsById',
    () {
      test(
        'should return a Product details when fetching product details by product id',
        () async {
          // Arrange
          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(productIdThreeModel.id)
              .set(productIdThreeModel.toJson());

          // Act
          final result =
              await productRemoteDataSource.getProductDetailsById(productId);

          // Assert
          expect(result, productIdThreeModel);
        },
      );

      test(
        'should throw DBException when a database operation fails while fetching product details by id',
        () async {
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(productId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Get product details by id failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.getProductDetailsById(productId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get product details by id failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'addFavorite',
    () {
      test(
        'should return a Product when updating the product\'s favorite list (add)',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(productId)
              .set(productIdThreeModel.toJson());

          // Act
          final result = await productRemoteDataSource.addFavorite(productId);

          // Assert
          expect(result, productIdThreeFavoriteModel);
        },
      );

      test(
        'should return a Product when updating the product\'s favorite list (remove)',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(productId)
              .set(productIdThreeFavoriteModel.toJson());

          // Act
          final result = await productRemoteDataSource.addFavorite(productId);

          // Assert
          expect(result, productIdThreeModel);
        },
      );

      test(
        'should throw AuthException if an error occurs while updating the product\'s favorite list',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.currentUser,
          ).thenThrow(
            FirebaseAuthException(
              code: 'unknown',
              message: AppErrorMessages.authenticationErrorOccurred,
            ),
          );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.addFavorite(productId),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                '[firebase_auth/unknown] ${AppErrorMessages.authenticationErrorOccurred}',
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException when a database operation fails while updating the product\'s favorite list',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(productId)
              .set(productIdThreeModel.toJson());

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(productId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Add favorite failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.addFavorite(productId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Add favorite failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'editProduct',
    () {
      test(
        'should return a Success Status when updating the product\'s details',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(beforeEditProductModel.id)
              .set(beforeEditProductModel.toJson());

          // Act
          final result =
              await productRemoteDataSource.editProduct(editedProductEntity);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should return a Failure Status when the product is not found',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Act
          final result =
              await productRemoteDataSource.editProduct(editedProductEntity);

          // Assert
          expect(result, ResponseTypes.failure.response);
        },
      );

      test(
        'should throw AuthException when the user is not found',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.editProduct(editedProductEntity),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.userNotFound,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException when a non-admin user attempts to update the product data',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userUserId)
              .set(userUserModel.toJson());

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.editProduct(editedProductEntity),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.unauthorizedAccess,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if an error occurs while updating the product\'s details',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.currentUser,
          ).thenThrow(
            FirebaseAuthException(
              code: 'unknown',
              message: AppErrorMessages.authenticationErrorOccurred,
            ),
          );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.editProduct(editedProductEntity),
            throwsA(
              isA<AuthException>().having(
                (e) => e.errorMessage,
                'message',
                '[firebase_auth/unknown] ${AppErrorMessages.authenticationErrorOccurred}',
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException when a database operation fails while updating the product\'s details',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userAdminId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add admin user data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.users)
              .doc(userAdminId)
              .set(userAdminModel.toJson());

          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(beforeEditProductModel.id)
              .set(beforeEditProductModel.toJson());

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(beforeEditProductModel.id)
              .collection(AppVariableNames.productData)
              .doc('files');

          whenCalling(Invocation.method(#set, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Edit product failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => productRemoteDataSource.editProduct(editedProductEntity),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Edit product failed',
              ),
            ),
          );
        },
      );
    },
  );
}

import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/category/category_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/auth_values.dart';
import '../../../../fixtures/category_values.dart';
import 'category_remote_data_source_test.mocks.dart';

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
  late CategoryRemoteDataSource categoryRemoteDataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirebaseFirestore = FakeFirebaseFirestore();

    categoryRemoteDataSource = CategoryRemoteDataSourceImpl(
      auth: mockFirebaseAuth,
      fireStore: fakeFirebaseFirestore,
    );
  });

  group(
    'addCategory',
    () {
      test(
        'should return a Success Status when adding a category to categories list',
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
              await categoryRemoteDataSource.addCategory(categoryTypeFont);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should return a Failure Status when adding an already exist category to categories list',
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

          // Add category data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.categories)
              .doc(fontCategoryModel.id)
              .set(fontCategoryModel.toJson());

          // Act
          final result =
              await categoryRemoteDataSource.addCategory(categoryTypeFont);

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
            () => categoryRemoteDataSource.addCategory(categoryTypeFont),
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
        'should throw AuthException when a non-admin user attempts to add category to categories list',
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
            () => categoryRemoteDataSource.addCategory(categoryTypeFont),
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
        'should throw AuthException if an error occurs while adding a category to categories list',
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
            () => categoryRemoteDataSource.addCategory(categoryTypeFont),
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
        'should throw DBException when a database operation fails while adding a category to categories list',
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
              mockCategoriesCollection = MockCollectionReference();
          final Query<Map<String, dynamic>> mockCategoriesQuery = MockQuery();

          when(mockFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollection);
          when(mockUserCollection.doc(userAdminId)).thenReturn(mockUserDocRef);
          when(mockUserDocRef.get())
              .thenAnswer((_) async => mockUserDocSnapshot);
          when(mockUserDocSnapshot.exists).thenReturn(true);
          when(mockUserDocSnapshot.data()).thenReturn(userAdminModel.toJson());

          when(mockFirestore.collection(AppVariableNames.categories))
              .thenReturn(mockCategoriesCollection);
          when(mockCategoriesCollection.where('name',
                  isEqualTo: categoryTypeFont))
              .thenReturn(mockCategoriesQuery);

          when(mockCategoriesQuery.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Add category failed',
            ),
          );

          final categoryRemoteDataSource = CategoryRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
          );

          // Act & Assert
          await expectLater(
            () => categoryRemoteDataSource.addCategory(categoryTypeFont),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Add category failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllCategories',
    () {
      test(
        'should return a List of Categories when fetching category data',
        () async {
          // Arrange
          // Add categories to FakeFirestore
          for (final model in categoryModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.categories)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result = await categoryRemoteDataSource.getAllCategories();

          // Assert
          expect(result, categoryModels);
        },
      );

      test(
        'should throw DBException when a database operation fails while fetching category data',
        () async {
          // Arrange
          final mockFirestore = MockFirebaseFirestore();

          final CollectionReference<Map<String, dynamic>>
              mockCategoriesCollection = MockCollectionReference();
          final Query<Map<String, dynamic>> mockCategoriesQuery = MockQuery();

          when(mockFirestore.collection(AppVariableNames.categories))
              .thenReturn(mockCategoriesCollection);
          when(mockCategoriesCollection.orderBy('dateCreated',
                  descending: true))
              .thenReturn(mockCategoriesQuery);

          when(mockCategoriesQuery.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Get all categories failed',
            ),
          );

          final categoryRemoteDataSource = CategoryRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
          );

          // Act & Assert
          await expectLater(
            () => categoryRemoteDataSource.getAllCategories(),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get all categories failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'deleteCategory',
    () {
      test(
        'should return a Success Status when deleting a category from the categories list',
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

          // Add category data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.categories)
              .doc(fontCategoryModel.id)
              .set(fontCategoryJson);

          // Act
          final result = await categoryRemoteDataSource
              .deleteCategory(fontCategoryId.toString());

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
            () => categoryRemoteDataSource
                .deleteCategory(fontCategoryId.toString()),
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
        'should throw AuthException when a non-admin user attempts to delete the category from the categories list',
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
            () => categoryRemoteDataSource
                .deleteCategory(fontCategoryId.toString()),
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
        'should throw AuthException if an error occurs while deleting a category from the categories list',
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
            () => categoryRemoteDataSource
                .deleteCategory(fontCategoryId.toString()),
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
        'should throw DBException when a database operation fails while deleting a category from the categories list',
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

          // Add category data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.categories)
              .doc(fontCategoryModel.id)
              .set(fontCategoryJson);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.categories)
              .doc(fontCategoryModel.id);

          whenCalling(Invocation.method(#delete, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Delete category failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => categoryRemoteDataSource
                .deleteCategory(fontCategoryId.toString()),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Delete category failed',
              ),
            ),
          );
        },
      );
    },
  );
}

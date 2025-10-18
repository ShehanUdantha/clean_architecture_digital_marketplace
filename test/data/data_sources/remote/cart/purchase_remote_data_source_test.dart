import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/data/data_sources/remote/cart/purchase_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/auth_values.dart';
import '../../../../fixtures/purchase_values.dart';
import 'purchase_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  User
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late PurchaseRemoteDataSource purchaseRemoteDataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirebaseFirestore = FakeFirebaseFirestore();

    purchaseRemoteDataSource = PurchaseRemoteDataSourceImpl(
      auth: mockFirebaseAuth,
      fireStore: fakeFirebaseFirestore,
    );
  });

  group(
    'getAllPurchaseHistoryByUserId',
    () {
      test(
        'should return a List of PurchaseModels when retrieving purchase history by user id',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          // Act
          final result =
              await purchaseRemoteDataSource.getAllPurchaseHistoryByUserId();

          // Assert
          expect(result, purchaseModels);
        },
      );

      test(
        'should throw AuthException if an error occurs while retrieving purchase history by user id',
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
            () => purchaseRemoteDataSource.getAllPurchaseHistoryByUserId(),
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
        'should throw DBException when a database operation fails while retrieving purchase history by user id',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Get all purchase history by user id failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => purchaseRemoteDataSource.getAllPurchaseHistoryByUserId(),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get all purchase history by user id failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllPurchaseItemsByItsProductIds',
    () {
      test(
        'should return a List of ProductsModels when retrieving purchased items by product id',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          // Add products data to FakeFirestore
          for (final model in purchasedProductModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result = await purchaseRemoteDataSource
              .getAllPurchaseItemsByItsProductIds(purchasedEntity);

          // Assert
          expect(result, purchasedProductModels);
        },
      );

      test(
        'should throw DBException when purchase history is not found',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: AppErrorMessages.purchaseHistoryNotFound,
                ),
              );

          // Act & Assert
          await expectLater(
            () => purchaseRemoteDataSource
                .getAllPurchaseItemsByItsProductIds(purchasedEntity),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] ${AppErrorMessages.purchaseHistoryNotFound}',
              ),
            ),
          );
        },
      );

      test(
        'should throw DBException when purchased products do not match',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedFailureJson);

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: AppErrorMessages
                      .productListDoesNotMatchWithPurchaseHistory,
                ),
              );

          // Act & Assert
          await expectLater(
            () => purchaseRemoteDataSource
                .getAllPurchaseItemsByItsProductIds(purchasedEntity),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] ${AppErrorMessages.productListDoesNotMatchWithPurchaseHistory}',
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException if an error occurs while retrieving purchased items by product id',
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
            () => purchaseRemoteDataSource
                .getAllPurchaseItemsByItsProductIds(purchasedEntity),
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
        'should throw DBException when a database operation fails while retrieving purchased items by product id',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          // Add product data to FakeFirestore
          for (final model in purchasedProductModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(purchasedProductModels[0].id);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Get all purchase items by product id failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => purchaseRemoteDataSource
                .getAllPurchaseItemsByItsProductIds(purchasedEntity),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get all purchase items by product id failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllPurchaseHistoryByMonth',
    () {
      test(
        'should return a Map of purchase history when retrieving purchase history for the provided month',
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

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .set({"id": userUserId});

          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          // Act
          final result =
              await purchaseRemoteDataSource.getAllPurchaseHistoryByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          expect(result, purchaseHistoryByYearAndMonth);
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
            () => purchaseRemoteDataSource.getAllPurchaseHistoryByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw AuthException when a non-admin user attempts to fetch purchase history data',
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
            () => purchaseRemoteDataSource.getAllPurchaseHistoryByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw AuthException if an error occurs while retrieving purchase history for the provided month',
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
            () => purchaseRemoteDataSource.getAllPurchaseHistoryByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw DBException when a database operation fails while retrieving purchase history for the provided month',
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
              mockPurchaseCollection = MockCollectionReference();

          when(mockFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollection);
          when(mockUserCollection.doc(userAdminId)).thenReturn(mockUserDocRef);
          when(mockUserDocRef.get())
              .thenAnswer((_) async => mockUserDocSnapshot);
          when(mockUserDocSnapshot.exists).thenReturn(true);
          when(mockUserDocSnapshot.data()).thenReturn(userAdminModel.toJson());

          when(mockFirestore.collection(AppVariableNames.purchase))
              .thenReturn(mockPurchaseCollection);

          when(mockPurchaseCollection.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Get all purchase history by month failed',
            ),
          );

          final purchaseRemoteDataSource = PurchaseRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
          );

          // Act & Assert
          await expectLater(
            () => purchaseRemoteDataSource.getAllPurchaseHistoryByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get all purchase history by month failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllPurchasesTotalBalanceByMonth',
    () {
      test(
        'should return a Total purchase amount when retrieving purchase history balance for the provided month',
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

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .set({"id": userUserId});

          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          // Act
          final result =
              await purchaseRemoteDataSource.getAllPurchasesTotalBalanceByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          expect(result, totalPurchaseAmountByYearAndMonth);
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
            () => purchaseRemoteDataSource.getAllPurchasesTotalBalanceByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw AuthException when a non-admin user attempts to fetch purchase history balance',
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
            () => purchaseRemoteDataSource.getAllPurchasesTotalBalanceByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw AuthException if an error occurs while retrieving purchase history balance for the provided month',
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
            () => purchaseRemoteDataSource.getAllPurchasesTotalBalanceByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw DBException when a database operation fails while retrieving purchase history balance for the provided month',
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
              mockPurchaseCollection = MockCollectionReference();

          when(mockFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollection);
          when(mockUserCollection.doc(userAdminId)).thenReturn(mockUserDocRef);
          when(mockUserDocRef.get())
              .thenAnswer((_) async => mockUserDocSnapshot);
          when(mockUserDocSnapshot.exists).thenReturn(true);
          when(mockUserDocSnapshot.data()).thenReturn(userAdminModel.toJson());

          when(mockFirestore.collection(AppVariableNames.purchase))
              .thenReturn(mockPurchaseCollection);

          when(mockPurchaseCollection.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Get all purchase total balance by month failed',
            ),
          );

          final purchaseRemoteDataSource = PurchaseRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
          );

          // Act & Assert
          await expectLater(
            () => purchaseRemoteDataSource.getAllPurchaseHistoryByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get all purchase total balance by month failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllPurchasesTotalBalancePercentageByMonth',
    () {
      test(
        'should return 100 as the total purchase amount percentage when retrieving purchase history balance percentage for the provided month',
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

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .set({"id": userUserId});

          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          // Act
          final result = await purchaseRemoteDataSource
              .getAllPurchasesTotalBalancePercentageByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          expect(result, totalPurchaseAmountPercentageByYearAndMonth);
        },
      );

      test(
        'should return 1150.052502625131 as the total purchase amount percentage when retrieving purchase history balance percentage for the provided month',
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

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .set({"id": userUserId});

          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedIdTwo)
              .set(purchasedJsonTwo);

          // Act
          final result = await purchaseRemoteDataSource
              .getAllPurchasesTotalBalancePercentageByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          expect(result, totalPurchaseAmountPercentageByYearAndMonthTwo);
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
            () => purchaseRemoteDataSource
                .getAllPurchasesTotalBalancePercentageByMonth(
                    yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw AuthException when a non-admin user attempts to fetch purchase history balance percentage',
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
            () => purchaseRemoteDataSource
                .getAllPurchasesTotalBalancePercentageByMonth(
                    yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw AuthException if an error occurs while retrieving purchase history balance percentage for the provided month',
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
            () => purchaseRemoteDataSource
                .getAllPurchasesTotalBalancePercentageByMonth(
                    yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw DBException when a database operation fails while retrieving purchase history balance percentage for the provided month',
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
              mockPurchaseCollection = MockCollectionReference();

          when(mockFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollection);
          when(mockUserCollection.doc(userAdminId)).thenReturn(mockUserDocRef);
          when(mockUserDocRef.get())
              .thenAnswer((_) async => mockUserDocSnapshot);
          when(mockUserDocSnapshot.exists).thenReturn(true);
          when(mockUserDocSnapshot.data()).thenReturn(userAdminModel.toJson());

          when(mockFirestore.collection(AppVariableNames.purchase))
              .thenReturn(mockPurchaseCollection);

          when(mockPurchaseCollection.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Get top selling products by month failed',
            ),
          );

          final purchaseRemoteDataSource = PurchaseRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
          );

          // Act & Assert
          await expectLater(
            () => purchaseRemoteDataSource
                .getAllPurchasesTotalBalancePercentageByMonth(
                    yearAndMonthParamsToGetPurchaseHistory),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get top selling products by month failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllTopSellingProductsByMonth',
    () {
      test(
        'should return a List of top selling products when retrieving top selling products for the provided month',
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

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .set({"id": userUserId});

          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          // Add product data to FakeFirestore
          for (final model in purchasedProductModels) {
            await fakeFirebaseFirestore
                .collection(AppVariableNames.products)
                .doc(model.id)
                .set(model.toJson());
          }

          // Act
          final result =
              await purchaseRemoteDataSource.getAllTopSellingProductsByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          expect(result, topSellingProductModelsByYearAndMonth);
        },
      );

      test(
        'should return an Empty List when no purchase history exists for the provided month',
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

          // Add purchase data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .set({"id": userUserId});

          await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .doc(purchasedId)
              .set(purchasedJson);

          // Act
          final result =
              await purchaseRemoteDataSource.getAllTopSellingProductsByMonth(
                  yearAndMonthParamsToGetPurchaseHistoryTwo);

          // Assert
          expect(result, []);
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
            () => purchaseRemoteDataSource.getAllTopSellingProductsByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw AuthException when a non-admin user attempts to fetch top selling products',
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
            () => purchaseRemoteDataSource.getAllTopSellingProductsByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw AuthException if an error occurs while retrieving top selling products for the provided month',
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
            () => purchaseRemoteDataSource.getAllPurchasesTotalBalanceByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
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
        'should throw DBException when a database operation fails while retrieving top selling products for the provided month',
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
              mockPurchaseCollection = MockCollectionReference();

          when(mockFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollection);
          when(mockUserCollection.doc(userAdminId)).thenReturn(mockUserDocRef);
          when(mockUserDocRef.get())
              .thenAnswer((_) async => mockUserDocSnapshot);
          when(mockUserDocSnapshot.exists).thenReturn(true);
          when(mockUserDocSnapshot.data()).thenReturn(userAdminModel.toJson());

          when(mockFirestore.collection(AppVariableNames.purchase))
              .thenReturn(mockPurchaseCollection);

          when(mockPurchaseCollection.get()).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message:
                  'Get all purchase total balance percentage by month failed',
            ),
          );

          final purchaseRemoteDataSource = PurchaseRemoteDataSourceImpl(
            fireStore: mockFirestore,
            auth: mockFirebaseAuth,
          );

          // Act & Assert
          await expectLater(
            () => purchaseRemoteDataSource.getAllTopSellingProductsByMonth(
                yearAndMonthParamsToGetPurchaseHistory),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get all purchase total balance percentage by month failed',
              ),
            ),
          );
        },
      );
    },
  );
}

import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/cart/cart_remote_data_source.dart';
import 'package:Pixelcart/src/data/models/product/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/constant_values.dart';
import 'cart_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  User,
  DocumentReference,
  DocumentSnapshot,
  CollectionReference,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {
  late CartRemoteDataSourceImpl cartRemoteDataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCartCollection;
  late MockDocumentReference<Map<String, dynamic>> mockCartDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockCartDocumentSnapshot;
  late MockUser mockUser;
  late MockCollectionReference<Map<String, dynamic>> mockProductCollection;
  late MockDocumentReference<Map<String, dynamic>> mockProductDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockProductDocumentSnapshot;
  late MockCollectionReference<Map<String, dynamic>> mockPurchaseCollection;
  late MockDocumentReference<Map<String, dynamic>>
      mockPurchaseDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockPurchaseDocumentSnapshot;
  late MockCollectionReference<Map<String, dynamic>> mockHistoryCollection;
  late MockDocumentReference<Map<String, dynamic>> mockHistoryDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockHistoryDocumentSnapshot;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCartCollection = MockCollectionReference<Map<String, dynamic>>();
    mockCartDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    mockCartDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    mockUser = MockUser();
    mockProductCollection = MockCollectionReference<Map<String, dynamic>>();
    mockProductDocumentReference =
        MockDocumentReference<Map<String, dynamic>>();
    mockProductDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    mockPurchaseCollection = MockCollectionReference<Map<String, dynamic>>();
    mockPurchaseDocumentReference =
        MockDocumentReference<Map<String, dynamic>>();
    mockPurchaseDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    mockHistoryCollection = MockCollectionReference<Map<String, dynamic>>();
    mockHistoryDocumentReference =
        MockDocumentReference<Map<String, dynamic>>();
    mockHistoryDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    cartRemoteDataSource = CartRemoteDataSourceImpl(
      auth: mockFirebaseAuth,
      fireStore: mockFirebaseFirestore,
    );
  });

  group(
    'addProductToCart',
    () {
      test(
        'should return a Success Status when the add product to cart process is successful',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);

          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentSnapshot.exists).thenReturn(true);
          when(mockCartDocumentReference.update({'ids': cartedDummyItemsIds}))
              .thenAnswer((_) async => Future.value());

          // Act
          final result =
              await cartRemoteDataSource.addProductToCart(fakeProductId);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should return a Success Status when the create a new cart if it does not exist process is successful',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);

          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentSnapshot.exists).thenReturn(false);
          when(mockCartDocumentReference.set({'ids': cartedDummyItemsIds}))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await cartRemoteDataSource.addProductToCart(fakeProductId);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should throw AuthException when FirebaseAuthException occurs',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser)
              .thenThrow(FirebaseAuthException(code: 'user-not-found'));

          // Act & Assert
          expect(() => cartRemoteDataSource.addProductToCart(fakeProductId),
              throwsA(isA<AuthException>()));
        },
      );

      test(
        'should throw DBException for unknown error',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Unknown error',
          );
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);
          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentSnapshot.exists).thenReturn(false);
          when(mockCartDocumentReference.set({'ids': cartedDummyItemsIds}))
              .thenThrow(dbException);

          // Act & Assert
          expect(
            () async =>
                await cartRemoteDataSource.addProductToCart(fakeProductId),
            throwsA(isA<DBException>()),
          );
        },
      );
    },
  );

  group(
    'getCartedItems',
    () {
      test(
        'should return a List of Carted Items Ids when the get carted items process is successful',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);

          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentSnapshot.exists).thenReturn(true);
          when(mockCartDocumentSnapshot.data())
              .thenAnswer((_) => {'ids': cartedDummyItemsIds});

          // Act
          final result = await cartRemoteDataSource.getCartedItems();

          // Assert
          expect(result, cartedDummyItemsIds);
        },
      );

      test(
        'should return a empty list (when cart does not exist) of Carted Items Ids when the get carted items process is successful',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);

          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentSnapshot.exists).thenReturn(false);

          // Act
          final result = await cartRemoteDataSource.getCartedItems();

          // Assert
          expect(result, []);
        },
      );

      test(
        'should throw AuthException when FirebaseAuthException occurs',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser)
              .thenThrow(FirebaseAuthException(code: 'user-not-found'));

          // Act & Assert
          expect(() => cartRemoteDataSource.getCartedItems(),
              throwsA(isA<AuthException>()));
        },
      );

      test(
        'should throw DBException for unknown error',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Unknown error',
          );
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);
          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentSnapshot.exists).thenReturn(true);
          when(mockCartDocumentSnapshot.data()).thenThrow(dbException);

          // Act & Assert
          expect(
            () async => await cartRemoteDataSource.getCartedItems(),
            throwsA(isA<DBException>()),
          );
        },
      );
    },
  );

  group(
    'removeProductFromCart',
    () {
      test(
        'should return a Success Status when the remove product from cart process is successful',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);

          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentReference
                  .update({'ids': cartedNewDummyItemsIds}))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await cartRemoteDataSource.removeProductFromCart(fakeProductId);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should throw AuthException when FirebaseAuthException occurs',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser)
              .thenThrow(FirebaseAuthException(code: 'user-not-found'));

          // Act & Assert
          expect(() => cartRemoteDataSource.removeProductFromCart('id1'),
              throwsA(isA<AuthException>()));
        },
      );

      test(
        'should throw DBException for unknown error',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Unknown error',
          );
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);
          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentReference
              .update({'ids': cartedNewDummyItemsIds})).thenThrow(dbException);

          // Act & Assert
          expect(
            () async => await cartRemoteDataSource.getCartedItems(),
            throwsA(isA<DBException>()),
          );
        },
      );
    },
  );

  group(
    'getAllCartedItemsDetailsById',
    () {
      test(
        'should return list of active products',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);

          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentSnapshot.exists).thenReturn(true);
          when(mockCartDocumentSnapshot.data()).thenAnswer((_) => {
                'ids': [cartedDummyItemsIds[0]]
              });

          when(mockFirebaseFirestore.collection(AppVariableNames.products))
              .thenReturn(mockProductCollection);
          when(mockProductCollection.doc(cartedDummyItemsIds[0]))
              .thenReturn(mockProductDocumentReference);
          when(mockProductDocumentReference.get())
              .thenAnswer((_) async => mockProductDocumentSnapshot);
          when(mockProductDocumentSnapshot.data());

          // Act
          final result =
              await cartRemoteDataSource.getAllCartedItemsDetailsById();

          // Assert
          expect(result, isA<List<ProductModel>>());
        },
      );
    },
  );

  group(
    'setCartDetailsToPurchaseHistoryAndDeleteCart',
    () {
      test(
        'should return a Success Status when the set cart details to purchase history and delete cart process is successful',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);

          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.get())
              .thenAnswer((_) async => mockCartDocumentSnapshot);
          when(mockCartDocumentSnapshot.exists).thenReturn(true);
          when(mockCartDocumentSnapshot.data())
              .thenAnswer((_) => {'ids': cartedDummyItemsIds});

          when(mockFirebaseFirestore.collection(AppVariableNames.purchase))
              .thenReturn(mockPurchaseCollection);
          when(mockPurchaseCollection.doc(userId))
              .thenReturn(mockPurchaseDocumentReference);
          when(mockPurchaseDocumentReference.set({'id': userId}))
              .thenAnswer((_) async => Future.value());

          when(mockPurchaseDocumentReference
                  .collection(AppVariableNames.history))
              .thenReturn(mockHistoryCollection);
          when(mockHistoryCollection.doc(fakePurchaseId))
              .thenReturn(mockHistoryDocumentReference);
          when(mockHistoryDocumentReference.set({
            'purchaseId': fakePurchaseId,
            'date': DateTime.timestamp(),
            'price': fakePurchaseItemsTotalPrice,
          })).thenAnswer((_) async => Future.value());
          when(mockHistoryDocumentReference.get())
              .thenAnswer((_) async => mockHistoryDocumentSnapshot);
          when(mockHistoryDocumentSnapshot.exists).thenReturn(true);
          when(mockHistoryDocumentReference
                  .update({'ids': cartedDummyItemsIds}))
              .thenAnswer((_) async => Future.value());

          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollection);
          when(mockCartCollection.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.delete())
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await cartRemoteDataSource
              .setCartDetailsToPurchaseHistoryAndDeleteCart(
                  fakePurchaseItemsTotalPrice);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );
    },
  );
}

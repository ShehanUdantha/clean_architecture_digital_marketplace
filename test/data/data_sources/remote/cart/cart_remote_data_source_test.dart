import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/cart/cart_remote_data_source.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/auth_values.dart';
import '../../../../fixtures/cart_values.dart';
import 'cart_remote_data_source_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late CartRemoteDataSourceImpl cartRemoteDataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirebaseFirestore = FakeFirebaseFirestore();

    cartRemoteDataSource = CartRemoteDataSourceImpl(
      auth: mockFirebaseAuth,
      fireStore: fakeFirebaseFirestore,
    );
  });

  group(
    'addProductToCart',
    () {
      test(
        'should return a Success Status and update the existing cart when adding a product to the cart',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({'ids': []});

          // Act
          final result =
              await cartRemoteDataSource.addProductToCart(cartedProductId);

          // Assert
          expect(result, ResponseTypes.success.response);

          final snap = await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .get();

          expect(snap.get('ids'), [cartedProductId]);
        },
      );

      test(
        'should return a Success Status and a new cart if it does not exist when adding a product to the cart',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act
          final result =
              await cartRemoteDataSource.addProductToCart(cartedProductId);

          // Assert
          expect(result, ResponseTypes.success.response);

          final snap = await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .get();

          expect(snap.get('ids'), [cartedProductId]);
        },
      );

      test(
        'should throw AuthException if an error occurs while adding a product to the cart',
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
            () => cartRemoteDataSource.addProductToCart(cartedProductId),
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
        'should throw DBException when a database operation fails while adding a product to the cart',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({'ids': []});

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Add product to cart failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => cartRemoteDataSource.addProductToCart(cartedProductId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Add product to cart failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getCartedItems',
    () {
      test(
        'should return a List of Carted Items Ids when fetching items from the cart',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({'ids': cartedProductsIds});

          // Act
          final result = await cartRemoteDataSource.getCartedItems();

          // Assert
          expect(result, cartedProductsIds);
        },
      );

      test(
        'should return an Empty List when the user cart does not exist',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act
          final result = await cartRemoteDataSource.getCartedItems();

          // Assert
          expect(result, []);
        },
      );

      test(
        'should throw AuthException if an error occurs while fetching items from the cart',
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
            () => cartRemoteDataSource.getCartedItems(),
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
        'should throw DBException when a database operation fails while fetching items from the cart',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({'ids': cartedProductsIds});

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Get carted items failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => cartRemoteDataSource.getCartedItems(),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get carted items failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'removeProductFromCart',
    () {
      test(
        'should return a Success Status when removing a product from the cart',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({'ids': cartedProductsIds});

          // Act
          final result =
              await cartRemoteDataSource.removeProductFromCart(cartedProductId);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should throw AuthException if an error occurs while removing a product from the cart',
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
            () => cartRemoteDataSource.removeProductFromCart(cartedProductId),
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
        'should throw DBException when a database operation fails while removing a product from the cart',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({'ids': cartedProductsIds});

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Remove product from cart failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => cartRemoteDataSource.addProductToCart(cartedProductId),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Remove product from cart failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'getAllCartedItemsDetailsById',
    () {
      test(
        'should return a List of Carted Items after retrieving all carted items details by id',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({
            'ids': [
              activeFirstProductModel.id,
              activeSecondProductModel.id,
              inactiveProductModel.id,
            ]
          });

          // Add product data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(activeFirstProductModel.id)
              .set(activeFirstProductModel.toJson());

          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(activeSecondProductModel.id)
              .set(activeSecondProductModel.toJson());

          await fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(inactiveProductModel.id)
              .set(inactiveProductModel.toJson());

          // Act
          final result =
              await cartRemoteDataSource.getAllCartedItemsDetailsById();

          // Assert
          expect(result, cartedProductModels);

          final cartSnap = await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .get();
          expect(
            cartSnap.get('ids'),
            [
              activeFirstProductModel.id,
              activeSecondProductModel.id,
            ],
          );
        },
      );

      test(
        'should return an Empty List when the user cart or ids filed does not exist',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Act
          final result =
              await cartRemoteDataSource.getAllCartedItemsDetailsById();

          // Assert
          expect(result, []);
        },
      );

      test(
        'should throw AuthException if an error occurs while retrieving all carted items details by id',
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
            () => cartRemoteDataSource.getAllCartedItemsDetailsById(),
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
        'should throw DBException when a database operation fails while retrieving all carted items details by id',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({'ids': cartedProductsIds});

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.products)
              .doc(activeFirstProductModel.id);

          whenCalling(Invocation.method(#get, [])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message: 'Get all carted items details by id failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => cartRemoteDataSource.getAllCartedItemsDetailsById(),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Get all carted items details by id failed',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'setCartDetailsToPurchaseHistoryAndDeleteCart',
    () {
      test(
        'should return a Success Status and delete the user cart when adding cart details to purchase history',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({'ids': cartedProductsIds});

          // Act
          final result = await cartRemoteDataSource
              .setCartDetailsToPurchaseHistoryAndDeleteCart(
                  cartedProductEntitiesListSubTotal.toString());

          // Assert
          expect(result, ResponseTypes.success.response);

          final cartDoc = await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .get();

          expect(cartDoc.exists, false);

          final purchaseHistory = await fakeFirebaseFirestore
              .collection(AppVariableNames.purchase)
              .doc(userUserId)
              .collection(AppVariableNames.history)
              .get();

          expect(purchaseHistory.docs.length, 1);

          final historyData = purchaseHistory.docs.first.data();

          expect(historyData['price'],
              cartedProductEntitiesListSubTotal.toString());
          expect(historyData['ids'], containsAll(cartedProductsIds));
        },
      );

      test(
        'should throw AuthException if an error occurs while adding cart details to purchase history and deleting the cart',
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
            () => cartRemoteDataSource
                .setCartDetailsToPurchaseHistoryAndDeleteCart(
                    cartedProductEntitiesListSubTotal.toString()),
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
        'should throw DBException when a database operation fails while adding cart details to purchase history and deleting the cart',
        () async {
          // Arrange
          final mockUser = MockUser();

          when(mockUser.uid).thenReturn(userUserId);
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

          // Add cart data to FakeFirestore
          await fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId)
              .set({'ids': cartedProductsIds});

          final docRef = fakeFirebaseFirestore
              .collection(AppVariableNames.cart)
              .doc(userUserId);

          whenCalling(Invocation.method(#delete,[
          ])).on(docRef).thenThrow(
                FirebaseException(
                  plugin: 'firestore',
                  message:
                      'Set cart details to purchase history and delete cart failed',
                ),
              );

          // Act & Assert
          await expectLater(
            () => cartRemoteDataSource
                .setCartDetailsToPurchaseHistoryAndDeleteCart(
                    cartedProductEntitiesListSubTotal.toString()),
            throwsA(
              isA<DBException>().having(
                (e) => e.errorMessage,
                'message',
                '[firestore/unknown] Set cart details to purchase history and delete cart failed',
              ),
            ),
          );
        },
      );
    },
  );
}

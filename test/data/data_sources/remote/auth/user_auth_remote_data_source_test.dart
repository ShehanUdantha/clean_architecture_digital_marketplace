import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/auth/user_auth_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/constant_values.dart';
import 'user_auth_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  FirebaseMessaging,
  User,
  UserCredential,
  DocumentSnapshot,
  DocumentReference,
  CollectionReference,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late UserAuthRemoteDataSourceImpl authRemoteDataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockFirebaseMessaging mockFirebaseMessaging;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockDocumentSnapshot<Map<String, dynamic>> mockUserDocumentSnapshot;
  late MockCollectionReference<Map<String, dynamic>>
      mockUserCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockUserDocumentReference;
  late MockQuerySnapshot<Map<String, dynamic>> mockUserQuerySnapshot;
  late MockCollectionReference<Map<String, dynamic>>
      mockCartCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockCartDocumentReference;

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockFirebaseMessaging = MockFirebaseMessaging();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockUserDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    mockUserCollectionReference =
        MockCollectionReference<Map<String, dynamic>>();
    mockUserQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockUserDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    mockCartCollectionReference =
        MockCollectionReference<Map<String, dynamic>>();
    mockCartDocumentReference = MockDocumentReference<Map<String, dynamic>>();

    authRemoteDataSource = UserAuthRemoteDataSourceImpl(
      auth: mockFirebaseAuth,
      fireStore: mockFirebaseFirestore,
      firebaseMessaging: mockFirebaseMessaging,
    );
  });

  group(
    'signInUser',
    () {
      test(
        'should return a User Id when the sign-in process is successful',
        () async {
          // Arrange
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: signInParams.email,
            password: signInParams.password,
          )).thenAnswer((_) async => mockUserCredential);

          when(mockUserCredential.user).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);
          when(mockUser.reload()).thenAnswer((_) async {});

          when(mockFirebaseFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollectionReference);
          when(mockUserCollectionReference.doc(userId))
              .thenReturn(mockUserDocumentReference);
          when(mockUserDocumentReference.get())
              .thenAnswer((_) async => mockUserDocumentSnapshot);

          when(mockUserDocumentSnapshot.exists).thenReturn(true);
          when(mockFirebaseMessaging.getToken())
              .thenAnswer((_) async => deviceToken);
          when(mockUserDocumentReference.update({'deviceToken': deviceToken}))
              .thenAnswer((_) async {});

          // Act
          final result = await authRemoteDataSource.signInUser(signInParams);

          // Assert
          expect(result, userId);
        },
      );

      test(
        'should throw AuthException when invalid email',
        () async {
          // Arrange
          final firebaseAuthException = FirebaseAuthException(
            code: 'invalid-email',
          );
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: signInParams.email,
            password: signInParams.password,
          )).thenThrow(firebaseAuthException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signInUser(signInParams),
            throwsA(isA<AuthException>()),
          );
        },
      );

      test(
        'should throw AuthException when user not found',
        () async {
          // Arrange
          final firebaseAuthException = FirebaseAuthException(
            code: 'user-not-found',
          );
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: signInParams.email,
            password: signInParams.password,
          )).thenThrow(firebaseAuthException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signInUser(signInParams),
            throwsA(isA<AuthException>()),
          );
        },
      );

      test(
        'should throw AuthException when wrong password',
        () async {
          // Arrange
          final firebaseAuthException = FirebaseAuthException(
            code: 'wrong-password',
          );
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: signInParams.email,
            password: signInParams.password,
          )).thenThrow(firebaseAuthException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signInUser(signInParams),
            throwsA(isA<AuthException>()),
          );
        },
      );

      test(
        'should throw AuthException when invalid credential',
        () async {
          // Arrange
          final firebaseAuthException = FirebaseAuthException(
            code: 'invalid-credential',
          );
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: signInParams.email,
            password: signInParams.password,
          )).thenThrow(firebaseAuthException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signInUser(signInParams),
            throwsA(isA<AuthException>()),
          );
        },
      );

      test(
        'should throw AuthException for unknown error',
        () async {
          // Arrange
          final firebaseAuthException = FirebaseAuthException(
            code: 'Unknown error',
          );
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: signInParams.email,
            password: signInParams.password,
          )).thenThrow(firebaseAuthException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signInUser(signInParams),
            throwsA(isA<AuthException>()),
          );
        },
      );
    },
  );

  group(
    'signUpUser',
    () {
      test(
        'should return Success Status when the sign-up process is successful',
        () async {
          // Arrange
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: signUpParams.email,
            password: signUpParams.password,
          )).thenAnswer((_) async => mockUserCredential);

          when(mockUserCredential.user).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(userId);

          when(authRemoteDataSource.getDeviceToken())
              .thenAnswer((_) async => deviceToken);

          when(mockFirebaseFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollectionReference);
          when(mockUserCollectionReference.doc(userId))
              .thenReturn(mockUserDocumentReference);
          when(mockUserDocumentReference.set(any)).thenAnswer((_) async {});

          when(mockFirebaseFirestore.collection(AppVariableNames.cart))
              .thenReturn(mockCartCollectionReference);
          when(mockCartCollectionReference.doc(userId))
              .thenReturn(mockCartDocumentReference);
          when(mockCartDocumentReference.set({'ids': []}))
              .thenAnswer((_) async {});

          // Act
          final result = await authRemoteDataSource.signUpUser(signUpParams);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should throw AuthException when weak password',
        () async {
          // Arrange
          final firebaseAuthException = FirebaseAuthException(
            code: 'weak-password',
          );
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: signUpParams.email,
            password: signUpParams.password,
          )).thenThrow(firebaseAuthException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signUpUser(signUpParams),
            throwsA(isA<AuthException>()),
          );
        },
      );

      test(
        'should throw AuthException when an email already in use',
        () async {
          // Arrange
          final firebaseAuthException = FirebaseAuthException(
            code: 'email-already-in-use',
          );
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: signUpParams.email,
            password: signUpParams.password,
          )).thenThrow(firebaseAuthException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signUpUser(signUpParams),
            throwsA(isA<AuthException>()),
          );
        },
      );

      test(
        'should throw AuthException when invalid email',
        () async {
          // Arrange
          final firebaseAuthException = FirebaseAuthException(
            code: 'invalid-email',
          );
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: signUpParams.email,
            password: signUpParams.password,
          )).thenThrow(firebaseAuthException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signUpUser(signUpParams),
            throwsA(isA<AuthException>()),
          );
        },
      );

      test(
        'should throw AuthException for unknown error',
        () async {
          // Arrange
          final firebaseAuthException = FirebaseAuthException(
            code: 'Unknown error',
          );
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: signUpParams.email,
            password: signUpParams.password,
          )).thenThrow(firebaseAuthException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signUpUser(signUpParams),
            throwsA(isA<AuthException>()),
          );
        },
      );
    },
  );

  group(
    'sendEmailVerification',
    () {
      test(
        'should return Success Status when the email verification send process is successful',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.sendEmailVerification()).thenAnswer((_) async {});

          // Act
          final result = await authRemoteDataSource.sendEmailVerification();

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should return Failure Status when currentUser is null',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          final result = await authRemoteDataSource.sendEmailVerification();

          // Assert
          expect(result, ResponseTypes.failure.response);
        },
      );

      test(
        'should throw AuthException for unknown error',
        () async {
          // Arrange
          final authException = AuthException(
            errorMessage: 'Unknown error',
          );
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.sendEmailVerification()).thenThrow(authException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.sendEmailVerification(),
            throwsA(isA<AuthException>()),
          );
        },
      );
    },
  );

  group(
    'checkEmailVerification',
    () {
      test(
        'should return a True if email is verified',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.emailVerified).thenReturn(true);

          // Act
          final result = await authRemoteDataSource.checkEmailVerification();

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return a False if email is not verified',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.emailVerified).thenReturn(false);

          // Act
          final result = await authRemoteDataSource.checkEmailVerification();

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return a False when currentUser is null',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          final result = await authRemoteDataSource.checkEmailVerification();

          // Assert
          expect(result, false);
        },
      );

      test(
        'should throw AuthException for unknown error',
        () async {
          // Arrange
          final authException = AuthException(
            errorMessage: 'Unknown error',
          );
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(authRemoteDataSource.checkEmailVerification())
              .thenThrow(authException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.checkEmailVerification(),
            throwsA(isA<AuthException>()),
          );
        },
      );
    },
  );

  group(
    'signOutUser',
    () {
      test(
        'should return Success Status when user signs out',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

          // Act
          final result = await authRemoteDataSource.signOutUser();

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should return Failure Status when currentUser is null',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          final result = await authRemoteDataSource.signOutUser();

          // Assert
          expect(result, ResponseTypes.failure.response);
        },
      );

      test(
        'should throw AuthException for unknown error',
        () async {
          // Arrange
          final authException = AuthException(
            errorMessage: 'Unknown error',
          );
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(authRemoteDataSource.signOutUser()).thenThrow(authException);

          // Act & Assert
          expect(
            () async => await authRemoteDataSource.signOutUser(),
            throwsA(isA<AuthException>()),
          );
        },
      );
    },
  );

  group(
    'forgotPassword',
    () {
      test(
        'should return Success Status when email exists in Firestore',
        () async {
          // Arrange
          when(mockFirebaseFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollectionReference);
          when(mockUserCollectionReference.where('email',
                  isEqualTo: forgotPwEmail))
              .thenReturn(mockUserCollectionReference);
          when(mockUserCollectionReference.get())
              .thenAnswer((_) async => mockUserQuerySnapshot);
          when(mockUserQuerySnapshot.docs)
              .thenReturn([MockQueryDocumentSnapshot()]);
          when(mockFirebaseAuth.sendPasswordResetEmail(email: forgotPwEmail))
              .thenAnswer((_) async {});

          // Act
          final result =
              await authRemoteDataSource.forgotPassword(forgotPwEmail);

          // Assert
          expect(result, ResponseTypes.success.response);
        },
      );

      test(
        'should return Failure Status when email does not exist in Firestore',
        () async {
          // Arrange
          when(mockFirebaseFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollectionReference);
          when(mockUserCollectionReference.where('email',
                  isEqualTo: forgotPwEmail))
              .thenReturn(mockUserCollectionReference);
          when(mockUserCollectionReference.get())
              .thenAnswer((_) async => mockUserQuerySnapshot);
          when(mockUserQuerySnapshot.docs).thenReturn([]);

          // Act
          final result =
              await authRemoteDataSource.forgotPassword(forgotPwEmail);

          // Assert
          expect(result, ResponseTypes.failure.response);
        },
      );

      test(
        'should throw AuthException for unknown error',
        () async {
          // Arrange
          final authException = AuthException(
            errorMessage: 'Unknown error',
          );

          when(mockFirebaseFirestore.collection(AppVariableNames.users))
              .thenReturn(mockUserCollectionReference);
          when(mockUserCollectionReference.where('email',
                  isEqualTo: forgotPwEmail))
              .thenReturn(mockUserCollectionReference);
          when(mockUserCollectionReference.get()).thenThrow(authException);

          // Act & Assert
          expect(
            () async =>
                await authRemoteDataSource.forgotPassword(forgotPwEmail),
            throwsA(isA<AuthException>()),
          );
        },
      );
    },
  );

  // TODO: Need to Impl
  group(
    'refreshUser',
    () {
      test(
        'should return a Firebase user when the refresh user process is successful',
        () async {},
      );

      test(
        'should return a Null value when the refresh user process is fails',
        () async {},
      );
    },
  );
}

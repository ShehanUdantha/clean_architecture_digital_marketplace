import '../../../../config/routes/router.dart';
import '../../../../core/constants/variable_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/extension.dart';
import '../../../../domain/usecases/auth/sign_in_params.dart';
import '../../../../domain/usecases/auth/sign_up_params.dart';
import '../../../models/user/user_model.dart';

abstract class UserAuthRemoteDataSource {
  Future<String> signInUser(SignInParams signInParams);
  Future<String> signUpUser(SignUpParams signUpParams);
  Future<String> sendEmailVerification();
  Future<bool> checkEmailVerification();
  Stream<User?> get user;
  Future<String> signOutUser();
  Future<String> forgotPassword(String email);
  Future<User?> refreshUser(User user);
}

class UserAuthRemoteDataSourceImpl implements UserAuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;
  final FirebaseMessaging firebaseMessaging;

  UserAuthRemoteDataSourceImpl({
    required this.auth,
    required this.fireStore,
    required this.firebaseMessaging,
  });

  @override
  Future<String> signInUser(SignInParams signInParams) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: signInParams.email,
        password: signInParams.password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw AuthException(
          errorMessage: rootNavigatorKey
                  .currentContext?.loc.authenticationErrorOccurred ??
              'An authentication error occurred.',
        );
      }

      await user.reload();
      final uid = user.uid;

      final result =
          await fireStore.collection(AppVariableNames.users).doc(uid).get();

      if (result.exists) {
        String deviceToken = await getDeviceToken();

        await fireStore.collection(AppVariableNames.users).doc(uid).update({
          "deviceToken": deviceToken,
        });
      }

      return uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.invalidEmail ??
              'Your email is not a valid email',
        );
      }
      if (e.code == 'user-not-found') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.userNotFound ??
              'This email not registered yet',
        );
      }
      if (e.code == 'wrong-password') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.wrongPassword ??
              'Your password is incorrect',
        );
      }
      if (e.code == 'invalid-credential') {
        throw AuthException(
          errorMessage:
              rootNavigatorKey.currentContext?.loc.invalidCredential ??
                  'Please check your email and password again',
        );
      } else {
        throw AuthException(errorMessage: e.toString());
      }
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw AuthException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String> signUpUser(SignUpParams signUpParams) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: signUpParams.email,
        password: signUpParams.password,
      );

      String deviceToken = await getDeviceToken();

      UserModel userAuthModel = UserModel(
        userId: credential.user!.uid,
        userType: 'user',
        userName: signUpParams.userName,
        email: signUpParams.email,
        password: signUpParams.password,
        deviceToken: deviceToken,
      );

      await fireStore
          .collection(AppVariableNames.users)
          .doc(credential.user!.uid)
          .set(
            userAuthModel.toJson(),
          );

      await fireStore
          .collection(AppVariableNames.cart)
          .doc(credential.user!.uid)
          .set({'ids': []});

      return ResponseTypes.success.response;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.weekPassword ??
              'your password is too weak',
        );
      } else if (e.code == 'email-already-in-use') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.emailAlreadyUsed ??
              'This email already registered',
        );
      } else if (e.code == 'invalid-email') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.invalidEmail ??
              'Your email is not a valid email',
        );
      } else {
        throw AuthException(errorMessage: e.toString());
      }
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw AuthException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String> sendEmailVerification() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        await auth.currentUser?.sendEmailVerification();
        return ResponseTypes.success.response;
      } else {
        return ResponseTypes.failure.response;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw AuthException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> checkEmailVerification() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        return await Future.value(auth.currentUser!.emailVerified);
      } else {
        return await Future.value(false);
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw AuthException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<User?> get user => auth.authStateChanges().map((authUser) => authUser);

  @override
  Future<String> signOutUser() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        await auth.signOut();
        return ResponseTypes.success.response;
      } else {
        return ResponseTypes.failure.response;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw AuthException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    try {
      final result = await fireStore
          .collection(AppVariableNames.users)
          .where('email', isEqualTo: email)
          .get();

      if (result.docs.length == 1) {
        await auth.sendPasswordResetEmail(email: email);
        return ResponseTypes.success.response;
      } else {
        return ResponseTypes.failure.response;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw AuthException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  Future<String> getDeviceToken() async {
    return await firebaseMessaging.getToken() ?? "";
  }
}

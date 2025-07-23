import '../../../../core/constants/error_messages.dart';

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
  Future<User?> signInUser(SignInParams signInParams);
  Future<String> signUpUser(SignUpParams signUpParams);
  Future<String> sendEmailVerification();
  Stream<User?> get user;
  Future<String> signOutUser();
  Future<String> forgotPassword(String email);
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
  Future<User?> signInUser(SignInParams signInParams) async {
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
              AppErrorMessages.authenticationErrorOccurred,
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

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.invalidEmail ??
              AppErrorMessages.invalidEmail,
        );
      }
      if (e.code == 'user-not-found') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.userNotFound ??
              AppErrorMessages.userNotFound,
        );
      }
      if (e.code == 'wrong-password') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.wrongPassword ??
              AppErrorMessages.wrongPassword,
        );
      }
      if (e.code == 'invalid-credential') {
        throw AuthException(
          errorMessage:
              rootNavigatorKey.currentContext?.loc.invalidCredential ??
                  AppErrorMessages.invalidCredential,
        );
      } else {
        throw AuthException(errorMessage: e.toString());
      }
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
        userType: UserTypes.user.name,
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
              AppErrorMessages.weekPassword,
        );
      } else if (e.code == 'email-already-in-use') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.emailAlreadyUsed ??
              AppErrorMessages.emailAlreadyUsed,
        );
      } else if (e.code == 'invalid-email') {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext?.loc.invalidEmail ??
              AppErrorMessages.invalidEmail,
        );
      } else {
        throw AuthException(errorMessage: e.toString());
      }
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
        await currentUser.reload();

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
      throw AuthException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<String> getDeviceToken() async {
    return await firebaseMessaging.getToken() ?? "";
  }
}

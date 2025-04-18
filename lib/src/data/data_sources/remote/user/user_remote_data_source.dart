// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/variable_names.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';
import '../../../models/user/user_model.dart';

abstract class UserRemoteDataSource {
  Future<String> getUserType(String userId);
  Future<UserModel> getUserDetails();
  Future<List<UserModel>> getAllUsers(String userType);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  UserRemoteDataSourceImpl({
    required this.fireStore,
    required this.auth,
  });

  @override
  Future<String> getUserType(String userId) async {
    try {
      final userDoc =
          await fireStore.collection(AppVariableNames.users).doc(userId).get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext?.loc.userNotFound ??
                AppErrorMessages.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      return userModel.userType;
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
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<UserModel> getUserDetails() async {
    try {
      final currentUser = auth.currentUser;

      final result = await fireStore
          .collection(AppVariableNames.users)
          .doc(currentUser!.uid)
          .get();

      return UserModel.fromDocument(result);
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
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<UserModel>> getAllUsers(String userType) async {
    try {
      final currentUser = auth.currentUser;

      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext?.loc.userNotFound ??
                AppErrorMessages.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        final result = userType != AppVariableNames.allUsersType
            ? await fireStore
                .collection(AppVariableNames.users)
                .where('userType', isEqualTo: userType.toLowerCase())
                .get()
            : await fireStore.collection(AppVariableNames.users).get();

        return List<UserModel>.from(
            (result.docs).map((e) => UserModel.fromDocument(e)));
      } else {
        throw AuthException(
          errorMessage:
              rootNavigatorKey.currentContext?.loc.unauthorizedAccess ??
                  AppErrorMessages.unauthorizedAccess,
        );
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
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}

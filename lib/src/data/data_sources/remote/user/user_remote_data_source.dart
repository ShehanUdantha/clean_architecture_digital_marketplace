// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/variable_names.dart';
import '../../../../core/error/exception.dart';
import '../../../models/user/user_model.dart';

abstract class UserRemoteDataSource {
  Future<String> getUserType(String id);
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
  Future<String> getUserType(String id) async {
    try {
      final result =
          await fireStore.collection(AppVariableNames.users).doc(id).get().then(
                (DocumentSnapshot value) =>
                    UserModel.fromMap(value.data() as Map<String, dynamic>),
              );
      return result.userType;
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    }
  }

  @override
  Future<UserModel> getUserDetails() async {
    try {
      final currentUser = auth.currentUser;
      try {
        final result = await fireStore
            .collection(AppVariableNames.users)
            .doc(currentUser!.uid)
            .get();

        return UserModel.fromDocument(result);
      } on FirebaseException catch (e) {
        throw DBException(errorMessage: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<UserModel>> getAllUsers(String userType) async {
    try {
      final result = userType != 'All Account'
          ? await fireStore
              .collection(AppVariableNames.users)
              .where('userType', isEqualTo: userType.toLowerCase())
              .get()
          : await fireStore.collection(AppVariableNames.users).get();

      return List<UserModel>.from(
          (result.docs).map((e) => UserModel.fromDocument(e)));
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }
}

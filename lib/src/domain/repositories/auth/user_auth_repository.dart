import '../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../usecases/auth/sign_in_params.dart';
import '../../usecases/auth/sign_up_params.dart';

abstract class UserAuthRepository {
  Future<Either<Failure, String>> signInUser(SignInParams signInParams);
  Future<Either<Failure, String>> signUpUser(SignUpParams signUpParams);
  Future<Either<Failure, String>> sendEmailVerification();
  Future<Either<Failure, bool>> checkEmailVerification();
  Stream<User?> get user;
  Future<Either<Failure, String>> signOutUser();
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<User?> refreshUser(User? user);
}

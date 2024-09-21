import '../../../domain/usecases/auth/sign_in_params.dart';
import '../../../domain/usecases/auth/sign_up_params.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../data_sources/remote/auth/user_auth_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/repositories/auth/user_auth_repository.dart';

class UserAuthRepositoryImpl implements UserAuthRepository {
  final UserAuthRemoteDataSource userAuthRemoteDataSource;

  UserAuthRepositoryImpl({required this.userAuthRemoteDataSource});

  @override
  Future<Either<Failure, String>> signInUser(SignInParams signInParams) async {
    try {
      final result = await userAuthRemoteDataSource.signInUser(signInParams);
      return Right(result);
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> signUpUser(SignUpParams signUpParams) async {
    try {
      final result = await userAuthRemoteDataSource.signUpUser(signUpParams);
      return Right(result);
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> sendEmailVerification() async {
    try {
      final result = await userAuthRemoteDataSource.sendEmailVerification();
      return Right(result);
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerification() async {
    try {
      final result = await userAuthRemoteDataSource.checkEmailVerification();
      return Right(result);
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Stream<User?> get user => userAuthRemoteDataSource.user;

  @override
  Future<Either<Failure, String>> signOutUser() async {
    try {
      final result = await userAuthRemoteDataSource.signOutUser();
      return Right(result);
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final result = await userAuthRemoteDataSource.forgotPassword(email);
      return Right(result);
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<User?> refreshUser(User? user) async {
    return await userAuthRemoteDataSource.refreshUser(user!);
  }
}

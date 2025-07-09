import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/auth/user_auth_repository.dart';
import 'sign_in_params.dart';

class UserSignInUseCase extends UseCase<User?, SignInParams> {
  final UserAuthRepository userAuthRepository;

  UserSignInUseCase({required this.userAuthRepository});

  @override
  Future<Either<Failure, User?>> call(SignInParams params) async {
    return await userAuthRepository.signInUser(params);
  }
}

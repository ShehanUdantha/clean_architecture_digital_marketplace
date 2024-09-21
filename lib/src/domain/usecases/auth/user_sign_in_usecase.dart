import 'sign_in_params.dart';

import '../../../core/error/failure.dart';
import '../../repositories/auth/user_auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecases/usecase.dart';

class UserSignInUseCase extends UseCase<String, SignInParams> {
  final UserAuthRepository userAuthRepository;

  UserSignInUseCase({required this.userAuthRepository});

  @override
  Future<Either<Failure, String>> call(SignInParams params) async {
    return await userAuthRepository.signInUser(params);
  }
}

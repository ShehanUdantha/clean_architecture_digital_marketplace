import 'sign_up_params.dart';

import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../repositories/auth/user_auth_repository.dart';
import 'package:dartz/dartz.dart';

class UserSignUpUseCase extends UseCase<String, SignUpParams> {
  final UserAuthRepository userAuthRepository;

  UserSignUpUseCase({required this.userAuthRepository});

  @override
  Future<Either<Failure, String>> call(SignUpParams params) async {
    return await userAuthRepository.signUpUser(params);
  }
}

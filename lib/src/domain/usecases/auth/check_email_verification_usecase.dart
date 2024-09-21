import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/auth/user_auth_repository.dart';

class CheckEmailVerificationUseCase extends UseCase<bool, NoParams> {
  final UserAuthRepository userAuthRepository;

  CheckEmailVerificationUseCase({required this.userAuthRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await userAuthRepository.checkEmailVerification();
  }
}

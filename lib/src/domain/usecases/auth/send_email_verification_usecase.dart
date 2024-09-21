import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../repositories/auth/user_auth_repository.dart';
import 'package:dartz/dartz.dart';

class SendEmailVerificationUseCase extends UseCase<String, NoParams> {
  final UserAuthRepository userAuthRepository;

  SendEmailVerificationUseCase({required this.userAuthRepository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await userAuthRepository.sendEmailVerification();
  }
}

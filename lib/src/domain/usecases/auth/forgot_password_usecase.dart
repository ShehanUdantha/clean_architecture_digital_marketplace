import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../repositories/auth/user_auth_repository.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordUseCase extends UseCase<String, String> {
  final UserAuthRepository userAuthRepository;

  ForgotPasswordUseCase({required this.userAuthRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await userAuthRepository.forgotPassword(params);
  }
}

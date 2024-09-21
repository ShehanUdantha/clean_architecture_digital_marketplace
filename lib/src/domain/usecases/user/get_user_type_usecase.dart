import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/user/user_repository.dart';

class GetUserTypeUseCase extends UseCase<String, String> {
  final UserRepository userRepository;

  GetUserTypeUseCase({required this.userRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return userRepository.getUserType(params);
  }
}

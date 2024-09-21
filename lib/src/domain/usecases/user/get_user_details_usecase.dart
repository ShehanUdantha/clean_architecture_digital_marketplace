import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/user/user_repository.dart';

class GetUserDetailsUseCase extends UseCase<UserEntity, NoParams> {
  final UserRepository userRepository;

  GetUserDetailsUseCase({required this.userRepository});

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await userRepository.getUserDetails();
  }
}

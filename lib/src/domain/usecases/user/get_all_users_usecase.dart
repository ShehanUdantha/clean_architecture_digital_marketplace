import 'get_all_users_params.dart';

import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/user/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllUsersUseCase extends UseCase<List<UserEntity>, GetAllUsersParams> {
  final UserRepository userRepository;

  GetAllUsersUseCase({required this.userRepository});

  @override
  Future<Either<Failure, List<UserEntity>>> call(
      GetAllUsersParams params) async {
    return await userRepository.getAllUsers(params);
  }
}

import '../../../core/usecases/usecase.dart';
import '../../../core/error/failure.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/user/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllUsersUseCase extends UseCase<List<UserEntity>, NoParams> {
  final UserRepository userRepository;

  GetAllUsersUseCase({required this.userRepository});

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) async {
    return await userRepository.getAllUsers();
  }
}

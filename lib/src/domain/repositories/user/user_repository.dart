import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/user/user_entity.dart';
import '../../usecases/user/get_all_users_params.dart';

abstract class UserRepository {
  Future<Either<Failure, String>> getUserType(String id);
  Future<Either<Failure, UserEntity>> getUserDetails();
  Future<Either<Failure, List<UserEntity>>> getAllUsers(
      GetAllUsersParams getAllUsersParams);
}

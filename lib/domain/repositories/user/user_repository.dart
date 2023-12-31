import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/user/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, String>> getUserType(String id);
  Future<Either<Failure, UserEntity>> getUserDetails();
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
}

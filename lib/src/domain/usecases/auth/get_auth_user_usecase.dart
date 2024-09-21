import 'package:firebase_auth/firebase_auth.dart';

import '../../repositories/auth/user_auth_repository.dart';

class GetAuthUserUseCase {
  final UserAuthRepository userAuthRepository;

  GetAuthUserUseCase({required this.userAuthRepository});

  Stream<User?> get user {
    return userAuthRepository.user;
  }
}

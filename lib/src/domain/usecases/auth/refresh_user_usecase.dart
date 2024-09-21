import '../../repositories/auth/user_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RefreshUserUseCase {
  final UserAuthRepository userAuthRepository;

  RefreshUserUseCase({required this.userAuthRepository});

  Future<User?> refreshUserCall(User? params) async {
    return await userAuthRepository.refreshUser(params);
  }
}

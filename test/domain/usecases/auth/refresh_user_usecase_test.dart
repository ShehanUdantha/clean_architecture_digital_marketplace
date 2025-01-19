import 'package:Pixelcart/src/domain/repositories/auth/user_auth_repository.dart';
import 'package:Pixelcart/src/domain/usecases/auth/refresh_user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'refresh_user_usecase_test.mocks.dart';

@GenerateMocks([UserAuthRepository, User])
void main() {
  late RefreshUserUseCase refreshUserUseCase;
  late MockUser mockFirebaseUser;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    mockFirebaseUser = MockUser();
    refreshUserUseCase =
        RefreshUserUseCase(userAuthRepository: mockUserAuthRepository);
  });

  test(
    'should return a Firebase user when the refresh user process is successful',
    () async {
      // Arrange
      when(mockUserAuthRepository.refreshUser(mockFirebaseUser))
          .thenAnswer((_) async => mockFirebaseUser);

      // Act
      final result = await refreshUserUseCase.refreshUserCall(mockFirebaseUser);

      // Assert
      expect(
        result,
        mockFirebaseUser,
      );
    },
  );

  test(
    'should return a Null value when the refresh user process is fails',
    () async {
      // Arrange
      when(mockUserAuthRepository.refreshUser(mockFirebaseUser))
          .thenAnswer((_) async => null);

      // Act
      final result = await refreshUserUseCase.refreshUserCall(mockFirebaseUser);

      // Assert
      expect(
        result,
        null,
      );
    },
  );
}

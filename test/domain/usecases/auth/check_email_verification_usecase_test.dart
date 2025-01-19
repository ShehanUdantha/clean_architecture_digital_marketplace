import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/usecases/usecase.dart';
import 'package:Pixelcart/src/domain/repositories/auth/user_auth_repository.dart';
import 'package:Pixelcart/src/domain/usecases/auth/check_email_verification_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_email_verification_usecase_test.mocks.dart';

@GenerateMocks([UserAuthRepository])
void main() {
  late CheckEmailVerificationUseCase checkEmailVerificationUseCase;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    checkEmailVerificationUseCase = CheckEmailVerificationUseCase(
        userAuthRepository: mockUserAuthRepository);
  });

  test(
    'should return a True when the email is verified',
    () async {
      // Arrange
      when(mockUserAuthRepository.checkEmailVerification())
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await checkEmailVerificationUseCase.call(NoParams());

      // Assert
      expect(result, const Right(true));
    },
  );

  test(
    'should return a False when the email is not verified',
    () async {
      // Arrange
      when(mockUserAuthRepository.checkEmailVerification())
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await checkEmailVerificationUseCase.call(NoParams());

      // Assert
      expect(result, const Right(false));
    },
  );

  test(
    'should return a False when the currentUser is null',
    () async {
      // Arrange
      when(mockUserAuthRepository.checkEmailVerification())
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await checkEmailVerificationUseCase.call(NoParams());

      // Assert
      expect(result, const Right(false));
    },
  );

  test(
    'should return a Failure when the check email verification process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Check email verification failed',
      );
      when(mockUserAuthRepository.checkEmailVerification())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await checkEmailVerificationUseCase.call(NoParams());

      // Assert
      expect(result, Left(failure));
    },
  );
}

import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/usecases/usecase.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/auth/user_auth_repository.dart';
import 'package:Pixelcart/src/domain/usecases/auth/send_email_verification_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'send_email_verification_usecase_test.mocks.dart';

@GenerateMocks([UserAuthRepository])
void main() {
  late SendEmailVerificationUseCase sendEmailVerificationUseCase;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    sendEmailVerificationUseCase = SendEmailVerificationUseCase(
        userAuthRepository: mockUserAuthRepository);
  });

  test(
    'should return a Success Status when the email verification sent process is successful',
    () async {
      // Arrange
      when(mockUserAuthRepository.sendEmailVerification())
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await sendEmailVerificationUseCase.call(NoParams());

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure Status when the currentUser is null',
    () async {
      // Arrange
      when(mockUserAuthRepository.sendEmailVerification())
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      // Act
      final result = await sendEmailVerificationUseCase.call(NoParams());

      // Assert
      expect(result, Right(ResponseTypes.failure.response));
    },
  );

  test(
    'should return a Failure when the email verification sent process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Email verification sent failed',
      );
      when(mockUserAuthRepository.sendEmailVerification())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await sendEmailVerificationUseCase.call(NoParams());

      // Assert
      expect(result, Left(failure));
    },
  );
}

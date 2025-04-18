import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/auth/user_auth_repository.dart';
import 'package:Pixelcart/src/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/auth_values.dart';
import 'forgot_password_usecase_test.mocks.dart';

@GenerateMocks([UserAuthRepository])
void main() {
  late ForgotPasswordUseCase forgotPasswordUseCase;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    forgotPasswordUseCase =
        ForgotPasswordUseCase(userAuthRepository: mockUserAuthRepository);
  });

  test(
    'should return a Success Status when the forgot password process is successful',
    () async {
      // Arrange
      when(mockUserAuthRepository.forgotPassword(userUserEmail))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await forgotPasswordUseCase.call(userUserEmail);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the email is not stored in firestore',
    () async {
      // Arrange
      when(mockUserAuthRepository.forgotPassword(userUserEmail))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      // Act
      final result = await forgotPasswordUseCase.call(userUserEmail);

      // Assert
      expect(result, Right(ResponseTypes.failure.response));
    },
  );

  test(
    'should return a Failure when the forgot password process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'forgot password failed',
      );
      when(mockUserAuthRepository.forgotPassword(userUserEmail))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await forgotPasswordUseCase.call(userUserEmail);

      // Assert
      expect(result, Left(failure));
    },
  );
}

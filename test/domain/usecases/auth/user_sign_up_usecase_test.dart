import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/auth/user_auth_repository.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_up_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/auth_values.dart';
import 'user_sign_up_usecase_test.mocks.dart';

@GenerateMocks([UserAuthRepository])
void main() {
  late UserSignUpUseCase userSignUpUseCase;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    userSignUpUseCase =
        UserSignUpUseCase(userAuthRepository: mockUserAuthRepository);
  });

  test(
    'should return a Success Status when the sign-up process is successful',
    () async {
      // Arrange
      when(mockUserAuthRepository.signUpUser(userSignUpParams))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await userSignUpUseCase.call(userSignUpParams);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the sign-up process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Sign-up failed',
      );
      when(mockUserAuthRepository.signUpUser(userSignUpParams))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await userSignUpUseCase.call(userSignUpParams);

      // Assert
      expect(result, Left(failure));
    },
  );
}

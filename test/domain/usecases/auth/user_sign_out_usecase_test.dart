import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/usecases/usecase.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/auth/user_auth_repository.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_out_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_sign_out_usecase_test.mocks.dart';

@GenerateMocks([UserAuthRepository])
void main() {
  late UserSignOutUseCase userSignOutUseCase;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    userSignOutUseCase =
        UserSignOutUseCase(userAuthRepository: mockUserAuthRepository);
  });

  test(
    'should return a Success Status when the sign-out process is successful',
    () async {
      // Arrange
      when(mockUserAuthRepository.signOutUser())
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await userSignOutUseCase.call(NoParams());

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure Status when the currentUser is null',
    () async {
      // Arrange
      when(mockUserAuthRepository.signOutUser())
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      // Act
      final result = await userSignOutUseCase.call(NoParams());

      // Assert
      expect(result, Right(ResponseTypes.failure.response));
    },
  );

  test(
    'should return a Failure when the sign-out process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Sign-out failed',
      );
      when(mockUserAuthRepository.signOutUser())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await userSignOutUseCase.call(NoParams());

      // Assert
      expect(result, Left(failure));
    },
  );
}

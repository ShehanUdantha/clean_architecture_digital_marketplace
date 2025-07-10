import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/auth/user_auth_repository.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_in_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../../fixtures/auth_values.dart';
import 'user_sign_in_usecase_test.mocks.dart';

// dart run build_runner build

@GenerateMocks([UserAuthRepository, User])
void main() {
  late MockUser mockFirebaseUser;
  late UserSignInUseCase userSignInUseCase;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockFirebaseUser = MockUser();
    mockUserAuthRepository = MockUserAuthRepository();
    userSignInUseCase =
        UserSignInUseCase(userAuthRepository: mockUserAuthRepository);
  });

  test(
    'should return a User Id when the sign-in process is successful',
    () async {
      // Arrange
      when(mockUserAuthRepository.signInUser(userSignInParams))
          .thenAnswer((_) async => Right(mockFirebaseUser));

      // Act
      final result = await userSignInUseCase(userSignInParams);

      // Assert
      expect(result, Right(mockFirebaseUser));
    },
  );

  test(
    'should return a Failure when the sign-in process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Sign-in failed',
      );
      when(mockUserAuthRepository.signInUser(userSignInParams))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await userSignInUseCase(userSignInParams);

      // Assert
      expect(result, Left(failure));
    },
  );
}

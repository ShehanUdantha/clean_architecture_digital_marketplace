import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/user/user_repository.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_user_type_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'get_user_type_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUserTypeUseCase getUserTypeUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    getUserTypeUseCase = GetUserTypeUseCase(userRepository: mockUserRepository);
  });

  test(
    'should return a user type according to the user id when the get user type process is successful',
    () async {
      // Arrange
      when(mockUserRepository.getUserType(dummyUserIdToGetUserType))
          .thenAnswer((_) async => Right(userTypeAdmin));

      // Act
      final result = await getUserTypeUseCase.call(dummyUserIdToGetUserType);

      // Assert
      expect(result, Right(userTypeAdmin));
    },
  );

  test(
    'should return a Failure when the get user type process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get user type failed',
      );
      when(mockUserRepository.getUserType(dummyUserIdToGetUserType))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getUserTypeUseCase.call(dummyUserIdToGetUserType);

      // Assert
      expect(result, Left(failure));
    },
  );
}

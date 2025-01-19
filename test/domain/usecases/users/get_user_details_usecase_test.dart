import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/usecases/usecase.dart';
import 'package:Pixelcart/src/domain/repositories/user/user_repository.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_user_details_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'get_user_details_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUserDetailsUseCase getUserDetailsUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    getUserDetailsUseCase =
        GetUserDetailsUseCase(userRepository: mockUserRepository);
  });

  test(
    'should return a Current user details when the get user details process is successful',
    () async {
      // Arrange
      when(mockUserRepository.getUserDetails())
          .thenAnswer((_) async => Right(userDetailsDummyModel));

      // Act
      final result = await getUserDetailsUseCase.call(NoParams());

      // Assert
      expect(result, Right(userDetailsDummyModel));
    },
  );

  test(
    'should return a Failure when the get user details process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get user details failed',
      );
      when(mockUserRepository.getUserDetails())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getUserDetailsUseCase.call(NoParams());

      // Assert
      expect(result, Left(failure));
    },
  );
}

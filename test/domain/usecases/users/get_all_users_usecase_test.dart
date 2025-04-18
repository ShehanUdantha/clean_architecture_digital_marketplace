import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/user/user_repository.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_all_users_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/users_values.dart';
import 'get_all_users_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetAllUsersUseCase getAllUsersUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    getAllUsersUseCase = GetAllUsersUseCase(userRepository: mockUserRepository);
  });

  test(
    'should return an All type of users when the get all users (userType - "All Account") process is successful',
    () async {
      // Arrange
      when(mockUserRepository.getAllUsers(userTypeForAll))
          .thenAnswer((_) async => const Right(allTypeOfUserEntities));

      // Act
      final result = await getAllUsersUseCase.call(userTypeForAll);

      // Assert
      expect(result, const Right(allTypeOfUserEntities));
    },
  );

  test(
    'should return Only users when the get all users (userType - "User") process is successful',
    () async {
      // Arrange
      when(mockUserRepository.getAllUsers(userTypeForUser))
          .thenAnswer((_) async => const Right(onlyUserEntities));

      // Act
      final result = await getAllUsersUseCase.call(userTypeForUser);

      // Assert
      expect(result, const Right(onlyUserEntities));
    },
  );

  test(
    'should return Only admins when the get all users (userType - "Admin") process is successful',
    () async {
      // Arrange
      when(mockUserRepository.getAllUsers(userTypeForAdmin))
          .thenAnswer((_) async => const Right(onlyAdminEntities));

      // Act
      final result = await getAllUsersUseCase.call(userTypeForAdmin);

      // Assert
      expect(result, const Right(onlyAdminEntities));
    },
  );

  test(
    'should return a Failure when the get all users (userType - "All Account") process is fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all users (userType - "All Account") failed',
      );
      when(mockUserRepository.getAllUsers(userTypeForAll))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllUsersUseCase.call(userTypeForAll);

      // Assert
      expect(result, Left(failure));
    },
  );

  test(
    'should return Failure when the get all users (userType - "User") process is fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all users (userType - "User") failed',
      );
      when(mockUserRepository.getAllUsers(userTypeForUser))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllUsersUseCase.call(userTypeForUser);

      // Assert
      expect(result, Left(failure));
    },
  );

  test(
    'should return Failure when the get all users (userType - "Admin") process is fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all users (userType - "Admin") failed',
      );
      when(mockUserRepository.getAllUsers(userTypeForAdmin))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllUsersUseCase.call(userTypeForAdmin);

      // Assert
      expect(result, Left(failure));
    },
  );
}

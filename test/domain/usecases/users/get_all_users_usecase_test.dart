import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/user/user_repository.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_all_users_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
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
      when(mockUserRepository.getAllUsers(getAllUsersParamsForAllTypes))
          .thenAnswer((_) async => const Right(allTypeOfDummyUsers));

      // Act
      final result =
          await getAllUsersUseCase.call(getAllUsersParamsForAllTypes);

      // Assert
      expect(result, const Right(allTypeOfDummyUsers));
    },
  );

  test(
    'should return Only users when the get all users (userType - "User") process is successful',
    () async {
      // Arrange
      when(mockUserRepository.getAllUsers(getAllUsersParamsForUserTypes))
          .thenAnswer((_) async => const Right(onlyDummyUsers));

      // Act
      final result =
          await getAllUsersUseCase.call(getAllUsersParamsForUserTypes);

      // Assert
      expect(result, const Right(onlyDummyUsers));
    },
  );

  test(
    'should return Only admins when the get all users (userType - "Admin") process is successful',
    () async {
      // Arrange
      when(mockUserRepository.getAllUsers(getAllUsersParamsForAdminTypes))
          .thenAnswer((_) async => const Right(onlyDummyAdmins));

      // Act
      final result =
          await getAllUsersUseCase.call(getAllUsersParamsForAdminTypes);

      // Assert
      expect(result, const Right(onlyDummyAdmins));
    },
  );

  test(
    'should return a Failure when the get all users (userType - "All Account") process is fails due to the unauthorized access',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage:
            'Get all users (userType - "All Account") failed - due to the unauthorized access',
      );
      when(mockUserRepository.getAllUsers(getAllUsersParamsForAllTypesTwo))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getAllUsersUseCase.call(getAllUsersParamsForAllTypesTwo);

      // Assert
      expect(result, Left(failure));
    },
  );

  test(
    'should return a Failure when the get all users (userType - "User") process is fails due to the unauthorized access',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage:
            'Get all users (userType - "User") failed - due to the unauthorized access',
      );
      when(mockUserRepository.getAllUsers(getAllUsersParamsForUserTypesTwo))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getAllUsersUseCase.call(getAllUsersParamsForUserTypesTwo);

      // Assert
      expect(result, Left(failure));
    },
  );

  test(
    'should return a Failure when the get all users (userType - "Admin") process is fails due to the unauthorized access',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage:
            'Get all users (userType - "Admin") failed - due to the unauthorized access',
      );
      when(mockUserRepository.getAllUsers(getAllUsersParamsForAdminTypesTwo))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getAllUsersUseCase.call(getAllUsersParamsForAdminTypesTwo);

      // Assert
      expect(result, Left(failure));
    },
  );

  test(
    'should return a Failure when the get all users (userType - "All Account") process is fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all users (userType - "All Account") failed',
      );
      when(mockUserRepository.getAllUsers(getAllUsersParamsForAllTypes))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getAllUsersUseCase.call(getAllUsersParamsForAllTypes);

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
      when(mockUserRepository.getAllUsers(getAllUsersParamsForUserTypes))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getAllUsersUseCase.call(getAllUsersParamsForUserTypes);

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
      when(mockUserRepository.getAllUsers(getAllUsersParamsForAdminTypes))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getAllUsersUseCase.call(getAllUsersParamsForAdminTypes);

      // Assert
      expect(result, Left(failure));
    },
  );
}

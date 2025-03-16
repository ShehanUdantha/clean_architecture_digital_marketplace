import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/data/data_sources/remote/user/user_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/user/user_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([UserRemoteDataSource])
void main() {
  late UserRepositoryImpl userRepositoryImpl;
  late MockUserRemoteDataSource mockUserRemoteDataSource;

  setUp(() {
    mockUserRemoteDataSource = MockUserRemoteDataSource();
    userRepositoryImpl =
        UserRepositoryImpl(userRemoteDataSource: mockUserRemoteDataSource);
  });

  group(
    'getUserDetails',
    () {
      test(
        'should return a Current user details when the get user details process is successful',
        () async {
          // Arrange
          when(mockUserRemoteDataSource.getUserDetails())
              .thenAnswer((_) async => userDetailsDummyModel);

          // Act
          final result = await userRepositoryImpl.getUserDetails();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, userDetailsDummyModel),
          );
        },
      );

      test(
        'should return a Failure when the get user details process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get user details failed',
          );
          when(mockUserRemoteDataSource.getUserDetails())
              .thenThrow(dbException);

          // Act
          final result = await userRepositoryImpl.getUserDetails();

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get user details failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getUserType',
    () {
      test(
        'should return a user type according to the user id when the get user type process is successful',
        () async {
          // Arrange
          when(mockUserRemoteDataSource.getUserType(dummyUserIdToGetUserType))
              .thenAnswer((_) async => userTypeAdmin);

          // Act
          final result =
              await userRepositoryImpl.getUserType(dummyUserIdToGetUserType);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, userTypeAdmin),
          );
        },
      );

      test(
        'should return a Failure when the get user type process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get user type failed',
          );
          when(mockUserRemoteDataSource.getUserType(dummyUserIdToGetUserType))
              .thenThrow(dbException);

          // Act
          final result =
              await userRepositoryImpl.getUserType(dummyUserIdToGetUserType);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get user type failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAllUsers',
    () {
      test(
        'should return an All type of users when the get all users (userType - "All Account") process is successful',
        () async {
          // Arrange
          when(mockUserRemoteDataSource.getAllUsers(userTypeForAll))
              .thenAnswer((_) async => allTypeOfDummyUsers);

          // Act
          final result = await userRepositoryImpl.getAllUsers(userTypeForAll);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, allTypeOfDummyUsers),
          );
        },
      );

      test(
        'should return Only users when the get all users (userType - "User") process is successful',
        () async {
          // Arrange
          when(mockUserRemoteDataSource.getAllUsers(userTypeForUser))
              .thenAnswer((_) async => onlyDummyUsers);

          // Act
          final result = await userRepositoryImpl.getAllUsers(userTypeForUser);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, onlyDummyUsers),
          );
        },
      );

      test(
        'should return Only admins when the get all users (userType - "Admin") process is successful',
        () async {
          // Arrange
          when(mockUserRemoteDataSource.getAllUsers(userTypeForAdmin))
              .thenAnswer((_) async => onlyDummyAdmins);

          // Act
          final result = await userRepositoryImpl.getAllUsers(userTypeForAdmin);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, onlyDummyAdmins),
          );
        },
      );

      test(
        'should return a Failure when the get all users (userType - "All Account") process is fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all users (userType - "All Account") failed',
          );
          when(mockUserRemoteDataSource.getAllUsers(userTypeForAll))
              .thenThrow(dbException);

          // Act
          final result = await userRepositoryImpl.getAllUsers(userTypeForAll);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all users (userType - "All Account") failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return Failure when the get all users (userType - "User") process is fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all users (userType - "User") failed',
          );
          when(mockUserRemoteDataSource.getAllUsers(userTypeForUser))
              .thenThrow(dbException);

          // Act
          final result = await userRepositoryImpl.getAllUsers(userTypeForUser);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all users (userType - "User") failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return Failure when the get all users (userType - "Admin") process is fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all users (userType - "Admin") failed',
          );
          when(mockUserRemoteDataSource.getAllUsers(userTypeForAdmin))
              .thenThrow(dbException);

          // Act
          final result = await userRepositoryImpl.getAllUsers(userTypeForAdmin);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all users (userType - "Admin") failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );
}

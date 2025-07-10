import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/services/network_service.dart';
import 'package:Pixelcart/src/data/data_sources/remote/user/user_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/user/user_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/auth_values.dart';
import '../../../fixtures/users_values.dart';
import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([UserRemoteDataSource, NetworkService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late UserRepositoryImpl userRepositoryImpl;
  late MockUserRemoteDataSource mockUserRemoteDataSource;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockUserRemoteDataSource = MockUserRemoteDataSource();
    mockNetworkService = MockNetworkService();
    userRepositoryImpl = UserRepositoryImpl(
      userRemoteDataSource: mockUserRemoteDataSource,
      networkService: mockNetworkService,
    );
  });

  group(
    'getUserDetails',
    () {
      test(
        'should return a Current user details when the get user details process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockUserRemoteDataSource.getUserDetails())
              .thenAnswer((_) async => userUserModel);

          // Act
          final result = await userRepositoryImpl.getUserDetails();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, userUserModel),
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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

      test(
        'should return a Failure when network fails in the get user details process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await userRepositoryImpl.getUserDetails();

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockUserRemoteDataSource.getUserType(userUserId))
              .thenAnswer((_) async => userTypeForUser);

          // Act
          final result = await userRepositoryImpl.getUserType(userUserId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, userTypeForUser),
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockUserRemoteDataSource.getUserType(userUserId))
              .thenThrow(dbException);

          // Act
          final result = await userRepositoryImpl.getUserType(userUserId);

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

      test(
        'should return a Failure when network fails in the get user type process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await userRepositoryImpl.getUserType(userUserId);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockUserRemoteDataSource.getAllUsers(userTypeForAll))
              .thenAnswer((_) async => allTypeOfUserModels);

          // Act
          final result = await userRepositoryImpl.getAllUsers(userTypeForAll);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, allTypeOfUserModels),
          );
        },
      );

      test(
        'should return Only users when the get all users (userType - "User") process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockUserRemoteDataSource.getAllUsers(userTypeForUser))
              .thenAnswer((_) async => onlyUserModels);

          // Act
          final result = await userRepositoryImpl.getAllUsers(userTypeForUser);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, onlyUserModels),
          );
        },
      );

      test(
        'should return Only admins when the get all users (userType - "Admin") process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockUserRemoteDataSource.getAllUsers(userTypeForAdmin))
              .thenAnswer((_) async => onlyAdminModels);

          // Act
          final result = await userRepositoryImpl.getAllUsers(userTypeForAdmin);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, onlyAdminModels),
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
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

      test(
        'should return a Failure when network fails in the get all users process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await userRepositoryImpl.getAllUsers(userTypeForAdmin);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );
}

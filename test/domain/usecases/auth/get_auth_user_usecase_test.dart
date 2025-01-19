import 'dart:async';

import 'package:Pixelcart/src/domain/repositories/auth/user_auth_repository.dart';
import 'package:Pixelcart/src/domain/usecases/auth/get_auth_user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_auth_user_usecase_test.mocks.dart';

@GenerateMocks([UserAuthRepository, User])
void main() {
  late GetAuthUserUseCase getAuthUserUseCase;
  late MockUser mockFirebaseUser;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    mockFirebaseUser = MockUser();
    getAuthUserUseCase =
        GetAuthUserUseCase(userAuthRepository: mockUserAuthRepository);
  });

  test(
    'should stream the current Firebase user from the repository',
    () async {
      // Arrange
      final userStreamController = StreamController<User?>();
      when(mockUserAuthRepository.user)
          .thenAnswer((_) => userStreamController.stream);

      // Act
      final resultStream = getAuthUserUseCase.user;

      // Assert
      expectLater(
        resultStream,
        emitsInOrder([
          mockFirebaseUser,
          emitsDone, // when the stream closes
        ]),
      );

      // emit values into the stream
      userStreamController.add(mockFirebaseUser);
      await userStreamController.close();

      verify(mockUserAuthRepository.user).called(1);
      verifyNoMoreInteractions(mockUserAuthRepository);
    },
  );

  test(
    'should stream null when there is no authenticated Firebase user',
    () async {
      // Arrange
      final userStreamController = StreamController<User?>();
      when(mockUserAuthRepository.user)
          .thenAnswer((_) => userStreamController.stream);

      // Act
      final resultStream = getAuthUserUseCase.user;

      // Assert
      expectLater(
        resultStream,
        emitsInOrder([
          null,
          emitsDone,
        ]),
      );

      userStreamController.add(null);
      await userStreamController.close();

      verify(mockUserAuthRepository.user).called(1);
      verifyNoMoreInteractions(mockUserAuthRepository);
    },
  );
}

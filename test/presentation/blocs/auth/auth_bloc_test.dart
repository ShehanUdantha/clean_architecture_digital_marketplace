import 'dart:async';

import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/auth/get_auth_user_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/refresh_user_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/auth/user_sign_out_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_user_type_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  GetAuthUserUseCase,
  GetUserTypeUseCase,
  UserSignOutUseCase,
  RefreshUserUseCase,
  User,
])
void main() {
  late AuthBloc authBloc;
  late MockGetAuthUserUseCase mockGetAuthUserUseCase;
  late MockGetUserTypeUseCase mockGetUserTypeUseCase;
  late MockUserSignOutUseCase mockUserSignOutUseCase;
  late MockRefreshUserUseCase mockRefreshUserUseCase;
  late MockUser mockUser;
  late StreamController<User?> userStreamController;

  setUp(() {
    mockGetAuthUserUseCase = MockGetAuthUserUseCase();
    mockGetUserTypeUseCase = MockGetUserTypeUseCase();
    mockUserSignOutUseCase = MockUserSignOutUseCase();
    mockRefreshUserUseCase = MockRefreshUserUseCase();
    mockUser = MockUser();
    userStreamController = StreamController<User?>();
    when(mockGetAuthUserUseCase.user)
        .thenAnswer((_) => userStreamController.stream);

    authBloc = AuthBloc(
      mockGetAuthUserUseCase,
      mockGetUserTypeUseCase,
      mockUserSignOutUseCase,
      mockRefreshUserUseCase,
    );
  });

  tearDown(() {
    userStreamController.close();
    authBloc.close();
  });

  blocTest<AuthBloc, AuthState>(
    'emits AuthSuccessState when CheckUserAuthEvent is added and use case return user type',
    build: () {
      when(mockUser.uid).thenReturn(dummyUserIdToGetUserType);

      when(mockGetUserTypeUseCase.call(dummyUserIdToGetUserType))
          .thenAnswer((_) async => Right(userTypeAdmin));
      return authBloc;
    },
    act: (bloc) => bloc.add(CheckUserAuthEvent(user: mockUser)),
    expect: () => [
      AuthSuccessState(
        userValue: mockUser,
        userTypeValue: userTypeAdmin,
        statusValue: BlocStatus.success,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthFailureState when CheckUserAuthEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get user type by id failed',
      );

      when(mockUser.uid).thenReturn(dummyUserIdToGetUserType);

      when(mockGetUserTypeUseCase.call(dummyUserIdToGetUserType))
          .thenAnswer((_) async => Left(failure));
      return authBloc;
    },
    act: (bloc) => bloc.add(CheckUserAuthEvent(user: mockUser)),
    expect: () => [
      AuthFailureState(
        statusValue: BlocStatus.error,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits SignOutState with success when SignOutEvent is added and use case return success',
    build: () {
      when(mockUserSignOutUseCase.call(any))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));
      return authBloc;
    },
    act: (bloc) => bloc.add(SignOutEvent()),
    expect: () => [
      const SignOutState(signOutStatusValue: BlocStatus.success),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits SignOutState with error when SignOutEvent is added and use case return success',
    build: () {
      when(mockUserSignOutUseCase.call(any))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));
      return authBloc;
    },
    act: (bloc) => bloc.add(SignOutEvent()),
    expect: () => [
      const SignOutState(signOutStatusValue: BlocStatus.error),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthFailureState when SignOutEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'User sign out failed',
      );

      when(mockUserSignOutUseCase.call(any))
          .thenAnswer((_) async => Left(failure));
      return authBloc;
    },
    act: (bloc) => bloc.add(SignOutEvent()),
    expect: () => [
      const AuthFailureState(statusValue: BlocStatus.error),
    ],
  );

  // TODO: need to implement
  // blocTest<AuthBloc, AuthState>(
  //   'emits updated AuthSuccessState when RefreshUserEvent is added',
  //   build: () {
  //     when(mockRefreshUserUseCase.refreshUserCall(mockUser))
  //         .thenAnswer((_) async => mockUser);
  //     return authBloc;
  //   },
  //   act: (bloc) => bloc.add(RefreshUserEvent()),
  //   expect: () => [],
  // );

  blocTest<AuthBloc, AuthState>(
    'emits InitialState when SetAuthStatusToDefault is added',
    build: () => authBloc,
    act: (bloc) => bloc.add(SetAuthStatusToDefault()),
    expect: () => [
      const InitialState(
        statusValue: BlocStatus.initial,
        userTypeValue: '',
        signOutStatusValue: BlocStatus.initial,
      )
    ],
  );
}

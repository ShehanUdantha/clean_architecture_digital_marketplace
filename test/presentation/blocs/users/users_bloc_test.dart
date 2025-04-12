import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_all_users_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/users/users_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'users_bloc_test.mocks.dart';

@GenerateMocks([GetAllUsersUseCase])
void main() {
  late UsersBloc usersBloc;
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;

  setUp(() {
    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
    usersBloc = UsersBloc(mockGetAllUsersUseCase);
  });

  tearDown(() {
    usersBloc.close();
  });

  blocTest<UsersBloc, UsersState>(
    'emits [loading, success, listOfUsers] when GetAllUsersEvent is added and usecase returns all type of users (userType - "All Account")',
    build: () {
      when(mockGetAllUsersUseCase.call(userTypeForAll))
          .thenAnswer((_) async => Right(allTypeOfDummyEntityUsers));

      return usersBloc;
    },
    act: (bloc) => bloc.add(GetAllUsersEvent()),
    expect: () => [
      const UsersState().copyWith(status: BlocStatus.loading),
      UsersState().copyWith(
        status: BlocStatus.success,
        listOfUsers: allTypeOfDummyEntityUsers,
      ),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emits [loading, error, message] when GetAllUsersEvent fails (userType - "All Account")',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get all users (userType - "All Account") failed',
      );
      when(mockGetAllUsersUseCase.call(userTypeForAll))
          .thenAnswer((_) async => Left(failure));
      return usersBloc;
    },
    act: (bloc) => bloc.add(GetAllUsersEvent()),
    expect: () => [
      const UsersState().copyWith(status: BlocStatus.loading),
      const UsersState().copyWith(
        status: BlocStatus.error,
        message: 'Get all users (userType - "All Account") failed',
      ),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emits [loading, success, listOfUsers] when GetAllUsersEvent is added and usecase returns all users (userType - "User")',
    build: () {
      when(mockGetAllUsersUseCase.call(userTypeForUser))
          .thenAnswer((_) async => Right(onlyDummyEntityUsers));
      return usersBloc;
    },
    act: (bloc) async {
      bloc.add(
        const UserTypeSelectEvent(
          value: userTypeIndexForUser,
          name: userTypeUser,
        ),
      );

      bloc.add(GetAllUsersEvent());
    },
    expect: () => [
      UsersState().copyWith(
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeUser,
      ),
      const UsersState().copyWith(
        status: BlocStatus.loading,
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeUser,
      ),
      UsersState().copyWith(
        status: BlocStatus.success,
        listOfUsers: onlyDummyEntityUsers,
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeUser,
      ),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emits [loading, error] when GetAllUsersEvent fails (userType - "User")',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get all users (userType - "User") failed',
      );
      when(mockGetAllUsersUseCase.call(userTypeForUser))
          .thenAnswer((_) async => Left(failure));
      return usersBloc;
    },
    act: (bloc) async {
      bloc.add(
        const UserTypeSelectEvent(
          value: userTypeIndexForUser,
          name: userTypeUser,
        ),
      );

      bloc.add(GetAllUsersEvent());
    },
    expect: () => [
      UsersState().copyWith(
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeUser,
      ),
      const UsersState().copyWith(
        status: BlocStatus.loading,
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeUser,
      ),
      UsersState().copyWith(
        status: BlocStatus.error,
        message: 'Get all users (userType - "User") failed',
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeUser,
      ),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emits [loading, success, listOfUsers] when GetAllUsersEvent is added and usecase returns all admins (userType - "Admin")',
    build: () {
      when(mockGetAllUsersUseCase.call(userTypeForAdmin))
          .thenAnswer((_) async => Right(onlyDummyEntityAdmins));

      return usersBloc;
    },
    act: (bloc) async {
      bloc.add(
        const UserTypeSelectEvent(
          value: userTypeIndexForAdmin,
          name: userTypeAdmin,
        ),
      );

      bloc.add(GetAllUsersEvent());
    },
    expect: () => [
      UsersState().copyWith(
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeAdmin,
      ),
      const UsersState().copyWith(
        status: BlocStatus.loading,
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeAdmin,
      ),
      UsersState().copyWith(
        status: BlocStatus.success,
        listOfUsers: onlyDummyEntityAdmins,
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeAdmin,
      ),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emits [loading, error] when GetAllUsersEvent fails (userType - "Admin")',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get all users (userType - "Admin") failed',
      );
      when(mockGetAllUsersUseCase.call(userTypeForAdmin))
          .thenAnswer((_) async => Left(failure));
      return usersBloc;
    },
    act: (bloc) async {
      bloc.add(
        const UserTypeSelectEvent(
          value: userTypeIndexForAdmin,
          name: userTypeAdmin,
        ),
      );

      bloc.add(GetAllUsersEvent());
    },
    expect: () => [
      UsersState().copyWith(
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeAdmin,
      ),
      const UsersState().copyWith(
        status: BlocStatus.loading,
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeAdmin,
      ),
      UsersState().copyWith(
        status: BlocStatus.error,
        message: 'Get all users (userType - "Admin") failed',
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeAdmin,
      ),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emits updated state with selected userTypeIndex and userTypeName when UserTypeSelectEvent is added',
    build: () => usersBloc,
    act: (bloc) => bloc.add(
      const UserTypeSelectEvent(
        value: userTypeIndexForUser,
        name: userTypeUser,
      ),
    ),
    expect: () => [
      const UsersState().copyWith(
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeUser,
      ),
    ],
  );
}

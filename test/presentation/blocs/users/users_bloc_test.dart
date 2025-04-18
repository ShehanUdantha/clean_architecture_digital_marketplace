import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_all_users_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/users/users_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/users_values.dart';
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
          .thenAnswer((_) async => Right(allTypeOfUserEntities));

      return usersBloc;
    },
    act: (bloc) => bloc.add(GetAllUsersEvent()),
    expect: () => [
      const UsersState().copyWith(status: BlocStatus.loading),
      UsersState().copyWith(
        status: BlocStatus.success,
        listOfUsers: allTypeOfUserEntities,
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
          .thenAnswer((_) async => Right(onlyUserEntities));
      return usersBloc;
    },
    act: (bloc) async {
      bloc.add(
        const UserTypeSelectEvent(
          value: userTypeIndexForUser,
          name: userTypeForUser,
        ),
      );

      bloc.add(GetAllUsersEvent());
    },
    expect: () => [
      UsersState().copyWith(
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeForUser,
      ),
      const UsersState().copyWith(
        status: BlocStatus.loading,
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeForUser,
      ),
      UsersState().copyWith(
        status: BlocStatus.success,
        listOfUsers: onlyUserEntities,
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeForUser,
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
          name: userTypeForUser,
        ),
      );

      bloc.add(GetAllUsersEvent());
    },
    expect: () => [
      UsersState().copyWith(
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeForUser,
      ),
      const UsersState().copyWith(
        status: BlocStatus.loading,
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeForUser,
      ),
      UsersState().copyWith(
        status: BlocStatus.error,
        message: 'Get all users (userType - "User") failed',
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeForUser,
      ),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emits [loading, success, listOfUsers] when GetAllUsersEvent is added and usecase returns all admins (userType - "Admin")',
    build: () {
      when(mockGetAllUsersUseCase.call(userTypeForAdmin))
          .thenAnswer((_) async => Right(onlyAdminEntities));

      return usersBloc;
    },
    act: (bloc) async {
      bloc.add(
        const UserTypeSelectEvent(
          value: userTypeIndexForAdmin,
          name: userTypeForAdmin,
        ),
      );

      bloc.add(GetAllUsersEvent());
    },
    expect: () => [
      UsersState().copyWith(
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeForAdmin,
      ),
      const UsersState().copyWith(
        status: BlocStatus.loading,
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeForAdmin,
      ),
      UsersState().copyWith(
        status: BlocStatus.success,
        listOfUsers: onlyAdminEntities,
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeForAdmin,
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
          name: userTypeForAdmin,
        ),
      );

      bloc.add(GetAllUsersEvent());
    },
    expect: () => [
      UsersState().copyWith(
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeForAdmin,
      ),
      const UsersState().copyWith(
        status: BlocStatus.loading,
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeForAdmin,
      ),
      UsersState().copyWith(
        status: BlocStatus.error,
        message: 'Get all users (userType - "Admin") failed',
        currentUserType: userTypeIndexForAdmin,
        currentUserTypeName: userTypeForAdmin,
      ),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emits updated state with selected userTypeIndex and userTypeName when UserTypeSelectEvent is added',
    build: () => usersBloc,
    act: (bloc) => bloc.add(
      const UserTypeSelectEvent(
        value: userTypeIndexForUser,
        name: userTypeForUser,
      ),
    ),
    expect: () => [
      const UsersState().copyWith(
        currentUserType: userTypeIndexForUser,
        currentUserTypeName: userTypeForUser,
      ),
    ],
  );
}

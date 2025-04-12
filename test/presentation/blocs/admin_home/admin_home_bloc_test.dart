import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/domain/entities/user/user_entity.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_history_by_month_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_total_balance_by_month_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_total_balance_percentage_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_top_sellings_products_by_month_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_user_details_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/admin_home/admin_home_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'admin_home_bloc_test.mocks.dart';

@GenerateMocks([
  GetUserDetailsUseCase,
  GetAllPurchaseHistoryByMonthUseCase,
  GetAllPurchaseBalanceByMonthUseCase,
  GetAllPurchaseBalancePercentageByMonthUseCase,
  GetTopSellingProductsByMonthUseCase,
])
void main() {
  late AdminHomeBloc adminHomeBloc;
  late MockGetUserDetailsUseCase mockGetUserDetailsUseCase;
  late MockGetAllPurchaseHistoryByMonthUseCase
      mockGetAllPurchaseHistoryByMonthUseCase;
  late MockGetAllPurchaseBalanceByMonthUseCase
      mockMockGetAllPurchaseBalanceByMonthUseCase;
  late MockGetAllPurchaseBalancePercentageByMonthUseCase
      mockGetAllPurchaseBalancePercentageByMonthUseCase;
  late MockGetTopSellingProductsByMonthUseCase
      mockGetTopSellingProductsByMonthUseCase;

  setUp(() {
    mockGetUserDetailsUseCase = MockGetUserDetailsUseCase();
    mockGetAllPurchaseHistoryByMonthUseCase =
        MockGetAllPurchaseHistoryByMonthUseCase();
    mockMockGetAllPurchaseBalanceByMonthUseCase =
        MockGetAllPurchaseBalanceByMonthUseCase();
    mockGetAllPurchaseBalancePercentageByMonthUseCase =
        MockGetAllPurchaseBalancePercentageByMonthUseCase();
    mockGetTopSellingProductsByMonthUseCase =
        MockGetTopSellingProductsByMonthUseCase();
    adminHomeBloc = AdminHomeBloc(
      mockGetUserDetailsUseCase,
      mockGetAllPurchaseHistoryByMonthUseCase,
      mockMockGetAllPurchaseBalanceByMonthUseCase,
      mockGetAllPurchaseBalancePercentageByMonthUseCase,
      mockGetTopSellingProductsByMonthUseCase,
    );
  });

  tearDown(() {
    adminHomeBloc.close();
  });

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits [userEntity] when GetAdminDetailsEvent is added and use case return userEntity',
    build: () {
      when(mockGetUserDetailsUseCase.call(any))
          .thenAnswer((_) async => Right(userDetailsDummyEntityModel));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetAdminDetailsEvent()),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(
        userEntity: userDetailsDummyEntityModel,
      ),
    ],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits no state when GetAdminDetailsEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get admin details failed',
      );
      when(mockGetUserDetailsUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetAdminDetailsEvent()),
    expect: () => [],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits updated state with userEntity when SetAdminDetailsToDefault is added',
    build: () => adminHomeBloc,
    act: (bloc) => bloc.add(SetAdminDetailsToDefault()),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(
        userEntity: const UserEntity(
          userId: '',
          userType: '',
          userName: '',
          email: '',
          password: '',
          deviceToken: '',
        ),
      ),
    ],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits updated state with year when UpdateYear is added',
    build: () => adminHomeBloc,
    act: (bloc) => bloc.add(
      UpdateYear(
        year: DateTime.now().year,
      ),
    ),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(
        year: DateTime.now().year,
      ),
    ],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits updated state with month when UpdateMonth is added',
    build: () => adminHomeBloc,
    act: (bloc) => bloc.add(
      UpdateMonth(
        month: DateTime.now().month,
      ),
    ),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(
        month: DateTime.now().month,
      ),
    ],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits [isMonthlyStatusLoading true, isMonthlyStatusLoading false, monthlyStatus] when GetMonthlyPurchaseStatus is added and use case return monthly status',
    build: () {
      when(mockGetAllPurchaseHistoryByMonthUseCase.call(any))
          .thenAnswer((_) async => Right(fakePurchaseHistoryByMonth));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetMonthlyPurchaseStatus()),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(isMonthlyStatusLoading: true),
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(
        isMonthlyStatusLoading: false,
        monthlyStatus: fakePurchaseHistoryByMonth,
      ),
    ],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits [isMonthlyStatusLoading true, isMonthlyStatusLoading false] when GetMonthlyPurchaseStatus fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get monthly purchase status failed',
      );
      when(mockGetAllPurchaseHistoryByMonthUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetMonthlyPurchaseStatus()),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(isMonthlyStatusLoading: true),
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(isMonthlyStatusLoading: false),
    ],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits [totalBalance] when GetMonthlyTotalBalance is added and use case return monthly total balance',
    build: () {
      when(mockMockGetAllPurchaseBalanceByMonthUseCase.call(any))
          .thenAnswer((_) async => Right(fakeTotalPurchaseAmount));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetMonthlyTotalBalance()),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(
        totalBalance: fakeTotalPurchaseAmount,
      ),
    ],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits no state when GetMonthlyTotalBalance fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get monthly total balance failed',
      );
      when(mockMockGetAllPurchaseBalanceByMonthUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetMonthlyTotalBalance()),
    expect: () => [],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits [totalBalancePercentage] when GetMonthlyTotalBalancePercentage is added and use case return monthly total balance percentage',
    build: () {
      when(mockGetAllPurchaseBalancePercentageByMonthUseCase.call(any))
          .thenAnswer((_) async => Right(fakeTotalPurchaseAmountPercentage));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetMonthlyTotalBalancePercentage()),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(
        totalBalancePercentage: fakeTotalPurchaseAmountPercentage,
      ),
    ],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits no state when GetMonthlyTotalBalancePercentage fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get monthly total balance percentage failed',
      );
      when(mockGetAllPurchaseBalancePercentageByMonthUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetMonthlyTotalBalancePercentage()),
    expect: () => [],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits [loading, success, listOfTopSellingProduct] when GetMonthlyTopSellingProducts is added and use case return list of top selling products',
    build: () {
      when(mockGetTopSellingProductsByMonthUseCase.call(any))
          .thenAnswer((_) async => Right(dummyTopSellingProducts));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetMonthlyTopSellingProducts()),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(monthlyTopSellingProductsListStatus: BlocStatus.loading),
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(
        monthlyTopSellingProductsListStatus: BlocStatus.success,
        listOfTopSellingProduct: dummyTopSellingProducts,
      ),
    ],
  );

  blocTest<AdminHomeBloc, AdminHomeState>(
    'emits [loading, error, monthlyTopSellingProductsListMessage] when GetMonthlyTopSellingProducts fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get list of top selling products failed',
      );
      when(mockGetTopSellingProductsByMonthUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return adminHomeBloc;
    },
    act: (bloc) => bloc.add(GetMonthlyTopSellingProducts()),
    expect: () => [
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(monthlyTopSellingProductsListStatus: BlocStatus.loading),
      AdminHomeState(
        year: DateTime.now().year,
        month: DateTime.now().month,
      ).copyWith(
        monthlyTopSellingProductsListStatus: BlocStatus.error,
        monthlyTopSellingProductsListMessage:
            'Get list of top selling products failed',
      ),
    ],
  );
}

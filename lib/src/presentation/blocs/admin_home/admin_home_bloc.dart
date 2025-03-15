import 'dart:async';

import '../../../domain/usecases/cart/purchase/year_and_month_params.dart';

import '../../../domain/entities/product/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum.dart';
import '../../../domain/usecases/cart/purchase/get_all_purchase_history_by_month_usecase.dart';
import '../../../domain/usecases/cart/purchase/get_all_purchase_total_balance_by_month_usecase.dart';
import '../../../domain/usecases/cart/purchase/get_all_purchase_total_balance_percentage_usecase.dart';
import '../../../domain/usecases/cart/purchase/get_top_sellings_products_by_month_usecase.dart';
import '../../../domain/usecases/user/get_user_details_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/user/user_entity.dart';

part 'admin_home_event.dart';
part 'admin_home_state.dart';

class AdminHomeBloc extends Bloc<AdminHomeEvent, AdminHomeState> {
  final GetUserDetailsUseCase getUserDetailsUseCase;
  final GetAllPurchaseHistoryByMonthUseCase getAllPurchaseHistoryByMonthUseCase;
  final GetAllPurchaseBalanceByMonthUseCase getAllPurchaseBalanceByMonthUseCase;
  final GetAllPurchaseBalancePercentageByMonthUseCase
      getAllPurchaseBalancePercentageByMonthUseCase;
  final GetTopSellingProductsByMonthUseCase getTopSellingProductsByMonthUseCase;

  AdminHomeBloc(
    this.getUserDetailsUseCase,
    this.getAllPurchaseHistoryByMonthUseCase,
    this.getAllPurchaseBalanceByMonthUseCase,
    this.getAllPurchaseBalancePercentageByMonthUseCase,
    this.getTopSellingProductsByMonthUseCase,
  ) : super(AdminHomeState(
          year: DateTime.now().year,
          month: DateTime.now().month,
        )) {
    on<GetAdminDetailsEvent>(onGetAdminDetailsEvent);
    on<SetAdminDetailsToDefault>(onSetAdminDetailsToDefault);
    on<UpdateYear>(onUpdateYear);
    on<UpdateMonth>(onUpdateMonth);
    on<GetMonthlyPurchaseStatus>(onGetMonthlyPurchaseStatus);
    on<GetMonthlyTotalBalance>(onGetMonthlyTotalBalance);
    on<GetMonthlyTotalBalancePercentage>(onGetMonthlyTotalBalancePercentage);
    on<GetMonthlyTopSellingProducts>(onGetMonthlyTopSellingProducts);
  }

  FutureOr<void> onGetAdminDetailsEvent(
    GetAdminDetailsEvent event,
    Emitter<AdminHomeState> emit,
  ) async {
    final result = await getUserDetailsUseCase.call(NoParams());
    result.fold(
      (l) => null,
      (r) => emit(
        state.copyWith(
          userEntity: r,
        ),
      ),
    );
  }

  FutureOr<void> onSetAdminDetailsToDefault(
    SetAdminDetailsToDefault event,
    Emitter<AdminHomeState> emit,
  ) {
    emit(
      state.copyWith(
        userEntity: const UserEntity(
          userId: '',
          userType: '',
          userName: '',
          email: '',
          password: '',
          deviceToken: '',
        ),
      ),
    );
  }

  FutureOr<void> onUpdateYear(
    UpdateYear event,
    Emitter<AdminHomeState> emit,
  ) {
    emit(
      state.copyWith(
        year: event.year,
      ),
    );
  }

  FutureOr<void> onUpdateMonth(
    UpdateMonth event,
    Emitter<AdminHomeState> emit,
  ) {
    emit(
      state.copyWith(
        month: event.month,
      ),
    );
  }

  FutureOr<void> onGetMonthlyPurchaseStatus(
    GetMonthlyPurchaseStatus event,
    Emitter<AdminHomeState> emit,
  ) async {
    emit(state.copyWith(isMonthlyStatusLoading: true));

    final result = await getAllPurchaseHistoryByMonthUseCase.call(
      YearAndMonthParams(
        year: state.year,
        month: state.month,
        userId: event.userId,
      ),
    );
    emit(state.copyWith(isMonthlyStatusLoading: false));

    result.fold(
      (l) => null,
      (r) => emit(
        state.copyWith(
          monthlyStatus: r,
        ),
      ),
    );
  }

  FutureOr<void> onGetMonthlyTotalBalance(
    GetMonthlyTotalBalance event,
    Emitter<AdminHomeState> emit,
  ) async {
    final result = await getAllPurchaseBalanceByMonthUseCase.call(
      YearAndMonthParams(
        year: state.year,
        month: state.month,
        userId: event.userId,
      ),
    );

    result.fold(
      (l) => null,
      (r) => emit(
        state.copyWith(
          totalBalance: r,
        ),
      ),
    );
  }

  FutureOr<void> onGetMonthlyTotalBalancePercentage(
    GetMonthlyTotalBalancePercentage event,
    Emitter<AdminHomeState> emit,
  ) async {
    final result = await getAllPurchaseBalancePercentageByMonthUseCase.call(
      YearAndMonthParams(
        year: state.year,
        month: state.month,
        userId: event.userId,
      ),
    );

    result.fold(
      (l) => null,
      (r) => emit(
        state.copyWith(
          totalBalancePercentage: r,
        ),
      ),
    );
  }

  FutureOr<void> onGetMonthlyTopSellingProducts(
    GetMonthlyTopSellingProducts event,
    Emitter<AdminHomeState> emit,
  ) async {
    emit(state.copyWith(
        monthlyTopSellingProductsListStatus: BlocStatus.loading));

    final result = await getTopSellingProductsByMonthUseCase.call(
      YearAndMonthParams(
        year: state.year,
        month: state.month,
        userId: event.userId,
      ),
    );

    result.fold(
      (l) => emit(
        state.copyWith(
          monthlyTopSellingProductsListMessage: l.errorMessage,
          monthlyTopSellingProductsListStatus: BlocStatus.error,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfTopSellingProduct: r,
          monthlyTopSellingProductsListStatus: BlocStatus.success,
        ),
      ),
    );
  }
}

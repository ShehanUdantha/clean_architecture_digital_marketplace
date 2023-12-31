import 'dart:async';

import '../../../domain/usecases/product/get_all_products_usecase.dart';
import 'package:bloc/bloc.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../core/utils/extension.dart';
import '../../../domain/usecases/category/get_all_categories_usecase.dart';
import '../../../domain/usecases/product/get_products_by_marketing_types_usecase.dart';
import '../../../domain/usecases/product/get_products_by_query_usecase.dart';
import '../../../domain/usecases/user/get_user_details_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/category/category_entity.dart';
import '../../../core/usecases/usecase.dart';
import '../../../../../core/utils/enum.dart';

part 'user_home_event.dart';
part 'user_home_state.dart';

class UserHomeBloc extends Bloc<UserHomeEvent, UserHomeState> {
  final GetUserDetailsUseCase getUserDetailsUseCase;
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final GetProductsByMarketingTypeUseCase getProductsByMarketingTypes;
  final GetProductsByQueryUseCase getProductsByQueryUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;

  UserHomeBloc(
    this.getUserDetailsUseCase,
    this.getAllCategoriesUseCase,
    this.getProductsByMarketingTypes,
    this.getAllProductsUseCase,
    this.getProductsByQueryUseCase,
  ) : super(const UserHomeState()) {
    on<GetUserDetailsEvent>(onGetUserDetailsEvent);
    on<GetCategoriesEvent>(onGetCategoriesEvent);
    on<CategoryClickedEvent>(onCategoryClickedEvent);
    on<GetFeaturedListEvent>(onGetFeaturedListEvent);
    on<GetTrendingListEvent>(onGetTrendingListEvent);
    on<GetLatestListEvent>(onGetLatestListEvent);
    on<GetProductsListByCategoryEvent>(onGetProductsListByCategoryEvent);
    on<SearchFieldChangeEvent>(onSearchFieldChangeEvent);
    on<GetProductsListByQueryEvent>(onGetProductsListByQueryEvent);
    on<ClearSearchFiledEvent>(onClearSearchFiledEvent);
    on<SetUserDetailsToDefault>(onSetUserDetailsToDefault);
  }

  FutureOr<void> onGetUserDetailsEvent(
    GetUserDetailsEvent event,
    Emitter<UserHomeState> emit,
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

  FutureOr<void> onGetCategoriesEvent(
    GetCategoriesEvent event,
    Emitter<UserHomeState> emit,
  ) async {
    final result = await getAllCategoriesUseCase.call(NoParams());
    result.fold(
      (l) => null,
      (r) => emit(
        state.copyWith(
          listOfCategories: r,
        ),
      ),
    );
  }

  FutureOr<void> onCategoryClickedEvent(
    CategoryClickedEvent event,
    Emitter<UserHomeState> emit,
  ) {
    emit(
      state.copyWith(
        currentCategory: event.value,
        currentCategoryName: event.name,
      ),
    );
  }

  FutureOr<void> onGetFeaturedListEvent(
    GetFeaturedListEvent event,
    Emitter<UserHomeState> emit,
  ) async {
    emit(state.copyWith(featuredStatus: BlocStatus.loading));

    final result =
        await getProductsByMarketingTypes.call(MarketingTypes.featured.types);
    result.fold(
      (l) => emit(
        state.copyWith(
          featuredStatus: BlocStatus.error,
          featuredMessage: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfFeatured: r,
          featuredStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onGetTrendingListEvent(
    GetTrendingListEvent event,
    Emitter<UserHomeState> emit,
  ) async {
    emit(state.copyWith(trendingStatus: BlocStatus.loading));

    final result =
        await getProductsByMarketingTypes.call(MarketingTypes.trending.types);
    result.fold(
      (l) => emit(
        state.copyWith(
          trendingStatus: BlocStatus.error,
          trendingMessage: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfTrending: r,
          trendingStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onGetLatestListEvent(
    GetLatestListEvent event,
    Emitter<UserHomeState> emit,
  ) async {
    emit(state.copyWith(latestStatus: BlocStatus.loading));

    final result =
        await getProductsByMarketingTypes.call(MarketingTypes.latest.types);
    result.fold(
      (l) => emit(
        state.copyWith(
          latestStatus: BlocStatus.error,
          latestMessage: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfLatest: r,
          latestStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onGetProductsListByCategoryEvent(
    GetProductsListByCategoryEvent event,
    Emitter<UserHomeState> emit,
  ) async {
    emit(state.copyWith(productsStatus: BlocStatus.loading));

    final result = await getAllProductsUseCase.call(state.currentCategoryName);
    result.fold(
      (l) => emit(
        state.copyWith(
          productsStatus: BlocStatus.error,
          productsMessage: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfProductsByCategory: r,
          productsStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onSearchFieldChangeEvent(
    SearchFieldChangeEvent event,
    Emitter<UserHomeState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  FutureOr<void> onGetProductsListByQueryEvent(
    GetProductsListByQueryEvent event,
    Emitter<UserHomeState> emit,
  ) async {
    emit(state.copyWith(searchProductsStatus: BlocStatus.loading));

    final result = await getProductsByQueryUseCase.call(state.searchQuery);
    result.fold(
      (l) => emit(
        state.copyWith(
          searchProductsStatus: BlocStatus.error,
          searchProductsMessage: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfSearchProducts: r,
          searchProductsStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onClearSearchFiledEvent(
    ClearSearchFiledEvent event,
    Emitter<UserHomeState> emit,
  ) {
    emit(
      state.copyWith(
        searchProductsMessage: '',
        searchProductsStatus: BlocStatus.initial,
        searchQuery: '',
        listOfSearchProducts: [],
      ),
    );
  }

  FutureOr<void> onSetUserDetailsToDefault(
    SetUserDetailsToDefault event,
    Emitter<UserHomeState> emit,
  ) {
    emit(
      state.copyWith(
        userEntity: const UserEntity(
          userId: '',
          userType: '',
          userName: '',
          email: '',
          password: '',
        ),
      ),
    );
  }
}

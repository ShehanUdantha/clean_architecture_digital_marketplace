import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/entities/user/user_entity.dart';
import 'package:Pixelcart/src/domain/usecases/category/get_all_categories_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/product/get_all_products_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/product/get_products_by_marketing_types_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/product/get_products_by_query_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/user/get_user_details_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/user_home/user_home_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/auth_values.dart';
import '../../../fixtures/category_values.dart';
import '../../../fixtures/product_values.dart';
import 'user_home_bloc_test.mocks.dart';

@GenerateMocks([
  GetUserDetailsUseCase,
  GetAllCategoriesUseCase,
  GetProductsByMarketingTypeUseCase,
  GetProductsByQueryUseCase,
  GetAllProductsUseCase,
])
void main() {
  late UserHomeBloc userHomeBloc;
  late MockGetUserDetailsUseCase mockGetUserDetailsUseCase;
  late MockGetAllCategoriesUseCase mockGetAllCategoriesUseCase;
  late MockGetProductsByMarketingTypeUseCase mockGetProductsByMarketingTypes;
  late MockGetProductsByQueryUseCase mockGetProductsByQueryUseCase;
  late MockGetAllProductsUseCase mockGetAllProductsUseCase;

  setUp(() {
    mockGetUserDetailsUseCase = MockGetUserDetailsUseCase();
    mockGetAllCategoriesUseCase = MockGetAllCategoriesUseCase();
    mockGetProductsByMarketingTypes = MockGetProductsByMarketingTypeUseCase();
    mockGetProductsByQueryUseCase = MockGetProductsByQueryUseCase();
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();
    userHomeBloc = UserHomeBloc(
      mockGetUserDetailsUseCase,
      mockGetAllCategoriesUseCase,
      mockGetProductsByMarketingTypes,
      mockGetAllProductsUseCase,
      mockGetProductsByQueryUseCase,
    );
  });

  tearDown(() {
    userHomeBloc.close();
  });

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [userEntity] when GetUserDetailsEvent is added and usecase return current user details',
    build: () {
      when(mockGetUserDetailsUseCase.call(any))
          .thenAnswer((_) async => Right(userUserEntity));

      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetUserDetailsEvent()),
    expect: () => [
      UserHomeState().copyWith(
        userEntity: userUserEntity,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits no state when GetUserDetailsEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get user details failed',
      );
      when(mockGetUserDetailsUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetUserDetailsEvent()),
    expect: () => [],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [listOfCategories] when GetCategoriesEvent is added and usecase return a list of categories',
    build: () {
      when(mockGetAllCategoriesUseCase.call(any))
          .thenAnswer((_) async => Right(categoryEntities));

      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetCategoriesEvent()),
    expect: () => [
      UserHomeState().copyWith(
        listOfCategories: categoryEntities,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits no state when GetCategoriesEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get categories failed',
      );
      when(mockGetAllCategoriesUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetCategoriesEvent()),
    expect: () => [],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits updated state with current categoryId and categoryName when CategoryClickedEvent is added',
    build: () => userHomeBloc,
    act: (bloc) => bloc.add(
      const CategoryClickedEvent(
        value: fontCategoryId,
        name: categoryTypeFont,
      ),
    ),
    expect: () => [
      const UserHomeState().copyWith(
        currentCategory: fontCategoryId,
        currentCategoryName: categoryTypeFont,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, success, listOfFeatured] when GetFeaturedListEvent is added and usecase return a list of featured products',
    build: () {
      when(mockGetProductsByMarketingTypes.call(MarketingTypes.featured.types))
          .thenAnswer((_) async => Right(featuredMarketingTypeProductEntities));

      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetFeaturedListEvent()),
    expect: () => [
      const UserHomeState().copyWith(featuredStatus: BlocStatus.loading),
      UserHomeState().copyWith(
        featuredStatus: BlocStatus.success,
        listOfFeatured: featuredMarketingTypeProductEntities,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, error, message] when GetFeaturedListEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get featured products list failed',
      );
      when(mockGetProductsByMarketingTypes.call(MarketingTypes.featured.types))
          .thenAnswer((_) async => Left(failure));
      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetFeaturedListEvent()),
    expect: () => [
      const UserHomeState().copyWith(featuredStatus: BlocStatus.loading),
      UserHomeState().copyWith(
        featuredStatus: BlocStatus.error,
        featuredMessage: 'Get featured products list failed',
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, success, listOfTrending] when GetTrendingListEvent is added and usecase return a list of trending products',
    build: () {
      when(mockGetProductsByMarketingTypes.call(MarketingTypes.trending.types))
          .thenAnswer((_) async => Right(trendingMarketingTypeProductEntities));

      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetTrendingListEvent()),
    expect: () => [
      const UserHomeState().copyWith(trendingStatus: BlocStatus.loading),
      UserHomeState().copyWith(
        trendingStatus: BlocStatus.success,
        listOfTrending: trendingMarketingTypeProductEntities,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, error, message] when GetTrendingListEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get trending products list failed',
      );
      when(mockGetProductsByMarketingTypes.call(MarketingTypes.trending.types))
          .thenAnswer((_) async => Left(failure));
      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetTrendingListEvent()),
    expect: () => [
      const UserHomeState().copyWith(trendingStatus: BlocStatus.loading),
      UserHomeState().copyWith(
        trendingStatus: BlocStatus.error,
        trendingMessage: 'Get trending products list failed',
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, success, listOfLatest] when GetLatestListEvent is added and usecase return a list of latest products',
    build: () {
      when(mockGetProductsByMarketingTypes.call(MarketingTypes.latest.types))
          .thenAnswer((_) async => Right(latestMarketingTypeProductEntities));

      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetLatestListEvent()),
    expect: () => [
      const UserHomeState().copyWith(latestStatus: BlocStatus.loading),
      UserHomeState().copyWith(
        latestStatus: BlocStatus.success,
        listOfLatest: latestMarketingTypeProductEntities,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, error, message] when GetLatestListEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get latest products list failed',
      );
      when(mockGetProductsByMarketingTypes.call(MarketingTypes.latest.types))
          .thenAnswer((_) async => Left(failure));
      return userHomeBloc;
    },
    act: (bloc) => bloc.add(GetLatestListEvent()),
    expect: () => [
      const UserHomeState().copyWith(latestStatus: BlocStatus.loading),
      UserHomeState().copyWith(
        latestStatus: BlocStatus.error,
        latestMessage: 'Get latest products list failed',
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, success, listOfUsers] when GetProductsListByCategoryEvent is added and usecase returns filtered products list according to the category',
    build: () {
      when(mockGetAllProductsUseCase.call(categoryTypeFont))
          .thenAnswer((_) async => Right(fontsCategoryProductModels));
      return userHomeBloc;
    },
    act: (bloc) async {
      bloc.add(
        const CategoryClickedEvent(
          value: fontCategoryId,
          name: categoryTypeFont,
        ),
      );

      bloc.add(GetProductsListByCategoryEvent());
    },
    expect: () => [
      UserHomeState().copyWith(
        currentCategory: fontCategoryId,
        currentCategoryName: categoryTypeFont,
      ),
      const UserHomeState().copyWith(
        productsStatus: BlocStatus.loading,
        currentCategory: fontCategoryId,
        currentCategoryName: categoryTypeFont,
      ),
      UserHomeState().copyWith(
        productsStatus: BlocStatus.success,
        listOfProductsByCategory: fontsCategoryProductModels,
        currentCategory: fontCategoryId,
        currentCategoryName: categoryTypeFont,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, error] when GetProductsListByCategoryEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get products list by category failed',
      );
      when(mockGetAllProductsUseCase.call(categoryTypeFont))
          .thenAnswer((_) async => Left(failure));
      return userHomeBloc;
    },
    act: (bloc) async {
      bloc.add(
        const CategoryClickedEvent(
          value: fontCategoryId,
          name: categoryTypeFont,
        ),
      );

      bloc.add(GetProductsListByCategoryEvent());
    },
    expect: () => [
      UserHomeState().copyWith(
        currentCategory: fontCategoryId,
        currentCategoryName: categoryTypeFont,
      ),
      const UserHomeState().copyWith(
        productsStatus: BlocStatus.loading,
        currentCategory: fontCategoryId,
        currentCategoryName: categoryTypeFont,
      ),
      UserHomeState().copyWith(
        productsStatus: BlocStatus.error,
        productsMessage: 'Get products list by category failed',
        currentCategory: fontCategoryId,
        currentCategoryName: categoryTypeFont,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits updated state with searchQuery when SearchFieldChangeEvent is added',
    build: () => userHomeBloc,
    act: (bloc) => bloc.add(
      const SearchFieldChangeEvent(
        query: productSearchQuery,
      ),
    ),
    expect: () => [
      const UserHomeState().copyWith(
        searchQuery: productSearchQuery,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, success, listOfSearchProducts] when GetProductsListByQueryEvent is added and usecase returns filtered products list according to the search query',
    build: () {
      when(mockGetProductsByQueryUseCase.call(productSearchQuery))
          .thenAnswer((_) async => Right(searchQueryResultProductEntities));
      return userHomeBloc;
    },
    act: (bloc) async {
      bloc.add(
        const SearchFieldChangeEvent(
          query: productSearchQuery,
        ),
      );

      bloc.add(GetProductsListByQueryEvent());
    },
    expect: () => [
      const UserHomeState().copyWith(
        searchQuery: productSearchQuery,
      ),
      const UserHomeState().copyWith(
        searchProductsStatus: BlocStatus.loading,
        searchQuery: productSearchQuery,
      ),
      UserHomeState().copyWith(
        searchProductsStatus: BlocStatus.success,
        listOfSearchProducts: searchQueryResultProductEntities,
        searchQuery: productSearchQuery,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits [loading, error] when GetProductsListByQueryEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get products list by search query failed',
      );
      when(mockGetProductsByQueryUseCase.call(productSearchQuery))
          .thenAnswer((_) async => Left(failure));
      return userHomeBloc;
    },
    act: (bloc) async {
      bloc.add(
        const SearchFieldChangeEvent(
          query: productSearchQuery,
        ),
      );

      bloc.add(GetProductsListByQueryEvent());
    },
    expect: () => [
      const UserHomeState().copyWith(
        searchQuery: productSearchQuery,
      ),
      const UserHomeState().copyWith(
        searchProductsStatus: BlocStatus.loading,
        searchQuery: productSearchQuery,
      ),
      UserHomeState().copyWith(
        searchProductsStatus: BlocStatus.error,
        searchProductsMessage: 'Get products list by search query failed',
        searchQuery: productSearchQuery,
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits updated state with searchQuery, searchProductsMessage, searchProductsStatus and listOfSearchProducts when ClearSearchFiledEvent is added',
    build: () => userHomeBloc,
    act: (bloc) => bloc.add(ClearSearchFiledEvent()),
    expect: () => [
      const UserHomeState().copyWith(
        searchProductsMessage: '',
        searchProductsStatus: BlocStatus.initial,
        searchQuery: '',
        listOfSearchProducts: [],
      ),
    ],
  );

  blocTest<UserHomeBloc, UserHomeState>(
    'emits updated state with userEntity when SetUserDetailsToDefault is added',
    build: () => userHomeBloc,
    act: (bloc) => bloc.add(SetUserDetailsToDefault()),
    expect: () => [
      UserHomeState().copyWith(
        userEntity: UserEntity(
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
}

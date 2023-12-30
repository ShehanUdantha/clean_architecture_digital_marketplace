part of 'user_home_bloc.dart';

class UserHomeState extends Equatable {
  final UserEntity userEntity;

  final List<CategoryEntity> listOfCategories;
  final int currentCategory;
  final String currentCategoryName;

  final List<ProductEntity> listOfFeatured;
  final BlocStatus featuredStatus;
  final String featuredMessage;
  final List<ProductEntity> listOfTrending;
  final BlocStatus trendingStatus;
  final String trendingMessage;
  final List<ProductEntity> listOfLatest;
  final BlocStatus latestStatus;
  final String latestMessage;

  final List<ProductEntity> listOfProductsByCategory;
  final BlocStatus productsStatus;
  final String productsMessage;

  final String searchQuery;
  final List<ProductEntity> listOfSearchProducts;
  final BlocStatus searchProductsStatus;
  final String searchProductsMessage;

  const UserHomeState({
    this.userEntity = const UserEntity(
      userId: '',
      userType: '',
      userName: '',
      email: '',
      password: '',
    ),
    this.listOfCategories = const [],
    this.currentCategory = 0,
    this.currentCategoryName = 'All Items',
    this.listOfFeatured = const [],
    this.featuredStatus = BlocStatus.initial,
    this.featuredMessage = '',
    this.listOfTrending = const [],
    this.trendingStatus = BlocStatus.initial,
    this.trendingMessage = '',
    this.listOfLatest = const [],
    this.latestStatus = BlocStatus.initial,
    this.latestMessage = '',
    this.listOfProductsByCategory = const [],
    this.productsStatus = BlocStatus.initial,
    this.productsMessage = '',
    this.searchQuery = '',
    this.listOfSearchProducts = const [],
    this.searchProductsStatus = BlocStatus.initial,
    this.searchProductsMessage = '',
  });

  UserHomeState copyWith({
    UserEntity? userEntity,
    List<CategoryEntity>? listOfCategories,
    int? currentCategory,
    String? currentCategoryName,
    List<ProductEntity>? listOfFeatured,
    BlocStatus? featuredStatus,
    String? featuredMessage,
    List<ProductEntity>? listOfTrending,
    BlocStatus? trendingStatus,
    String? trendingMessage,
    List<ProductEntity>? listOfLatest,
    BlocStatus? latestStatus,
    String? latestMessage,
    List<ProductEntity>? listOfProductsByCategory,
    BlocStatus? productsStatus,
    String? productsMessage,
    String? searchQuery,
    List<ProductEntity>? listOfSearchProducts,
    BlocStatus? searchProductsStatus,
    String? searchProductsMessage,
  }) =>
      UserHomeState(
        userEntity: userEntity ?? this.userEntity,
        listOfCategories: listOfCategories ?? this.listOfCategories,
        currentCategory: currentCategory ?? this.currentCategory,
        currentCategoryName: currentCategoryName ?? this.currentCategoryName,
        listOfFeatured: listOfFeatured ?? this.listOfFeatured,
        featuredStatus: featuredStatus ?? this.featuredStatus,
        featuredMessage: featuredMessage ?? this.featuredMessage,
        listOfTrending: listOfTrending ?? this.listOfTrending,
        trendingStatus: trendingStatus ?? this.trendingStatus,
        trendingMessage: trendingMessage ?? this.trendingMessage,
        listOfLatest: listOfLatest ?? this.listOfLatest,
        latestStatus: latestStatus ?? this.latestStatus,
        latestMessage: latestMessage ?? this.latestMessage,
        listOfProductsByCategory:
            listOfProductsByCategory ?? this.listOfProductsByCategory,
        productsStatus: productsStatus ?? this.productsStatus,
        productsMessage: productsMessage ?? this.productsMessage,
        searchQuery: searchQuery ?? this.searchQuery,
        listOfSearchProducts: listOfSearchProducts ?? this.listOfSearchProducts,
        searchProductsStatus: searchProductsStatus ?? this.searchProductsStatus,
        searchProductsMessage:
            searchProductsMessage ?? this.searchProductsMessage,
      );

  @override
  List<Object> get props => [
        userEntity,
        listOfCategories,
        currentCategory,
        currentCategoryName,
        listOfFeatured,
        featuredStatus,
        featuredMessage,
        listOfTrending,
        trendingStatus,
        trendingMessage,
        listOfLatest,
        latestStatus,
        latestMessage,
        listOfProductsByCategory,
        productsStatus,
        productsMessage,
        searchQuery,
        listOfSearchProducts,
        searchProductsStatus,
        searchProductsMessage,
      ];
}

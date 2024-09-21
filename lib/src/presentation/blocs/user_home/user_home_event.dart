part of 'user_home_bloc.dart';

sealed class UserHomeEvent extends Equatable {
  const UserHomeEvent();

  @override
  List<Object> get props => [];
}

class GetUserDetailsEvent extends UserHomeEvent {}

class GetCategoriesEvent extends UserHomeEvent {}

class CategoryClickedEvent extends UserHomeEvent {
  final int value;
  final String name;

  const CategoryClickedEvent({
    required this.value,
    required this.name,
  });
}

class GetFeaturedListEvent extends UserHomeEvent {}

class GetTrendingListEvent extends UserHomeEvent {}

class GetLatestListEvent extends UserHomeEvent {}

class GetProductsListByCategoryEvent extends UserHomeEvent {}

class SearchFieldChangeEvent extends UserHomeEvent {
  final String query;

  const SearchFieldChangeEvent({required this.query});
}

class GetProductsListByQueryEvent extends UserHomeEvent {}

class ClearSearchFiledEvent extends UserHomeEvent {}

class SetUserDetailsToDefault extends UserHomeEvent {}

part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryButtonClickedEvent extends CategoryEvent {
  final String category;

  const CategoryButtonClickedEvent({required this.category});
}

class SetCategoryAddStatusToDefault extends CategoryEvent {}

class GetAllCategoriesEvent extends CategoryEvent {}

class DeleteCategoriesEvent extends CategoryEvent {
  final String id;

  const DeleteCategoriesEvent({required this.id});
}

class SetDeleteStateToDefault extends CategoryEvent {}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryAddButtonClickedEvent extends CategoryEvent {
  final String category;

  const CategoryAddButtonClickedEvent({
    required this.category,
  });
}

class SetCategoryAddStatusToDefault extends CategoryEvent {}

class GetAllCategoriesEvent extends CategoryEvent {}

class DeleteCategoriesEvent extends CategoryEvent {
  final String categoryId;

  const DeleteCategoriesEvent({
    required this.categoryId,
  });
}

class SetDeleteStateToDefault extends CategoryEvent {}

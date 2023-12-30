part of 'add_category_bloc.dart';

sealed class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryButtonClickedEvent extends AddCategoryEvent {
  final String category;

  const CategoryButtonClickedEvent({required this.category});
}

class SetCategoryStatusToDefault extends AddCategoryEvent {}

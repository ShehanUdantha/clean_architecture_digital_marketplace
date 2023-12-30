part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final BlocStatus status;
  final String message;
  final List<CategoryEntity> listOfCategories;
  final bool isDeleted;

  const CategoryState({
    this.status = BlocStatus.initial,
    this.message = '',
    this.listOfCategories = const [],
    this.isDeleted = false,
  });

  CategoryState copyWith({
    BlocStatus? status,
    String? message,
    List<CategoryEntity>? listOfCategories,
    bool? isDeleted,
  }) =>
      CategoryState(
        status: status ?? this.status,
        message: message ?? this.message,
        listOfCategories: listOfCategories ?? this.listOfCategories,
        isDeleted: isDeleted ?? this.isDeleted,
      );

  @override
  List<Object> get props => [
        status,
        message,
        listOfCategories,
        isDeleted,
      ];
}

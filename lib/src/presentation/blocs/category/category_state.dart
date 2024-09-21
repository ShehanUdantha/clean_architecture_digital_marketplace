part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final String category;
  final BlocStatus categoryAddStatus;
  final String categoryAddMessage;

  final BlocStatus status;
  final String message;
  final List<CategoryEntity> listOfCategories;
  final bool isDeleted;

  const CategoryState({
    this.category = '',
    this.categoryAddStatus = BlocStatus.initial,
    this.categoryAddMessage = '',
    this.status = BlocStatus.initial,
    this.message = '',
    this.listOfCategories = const [],
    this.isDeleted = false,
  });

  CategoryState copyWith({
    String? category,
    BlocStatus? categoryAddStatus,
    String? categoryAddMessage,
    BlocStatus? status,
    String? message,
    List<CategoryEntity>? listOfCategories,
    bool? isDeleted,
  }) =>
      CategoryState(
        category: category ?? this.category,
        categoryAddStatus: categoryAddStatus ?? this.categoryAddStatus,
        categoryAddMessage: categoryAddMessage ?? this.categoryAddMessage,
        status: status ?? this.status,
        message: message ?? this.message,
        listOfCategories: listOfCategories ?? this.listOfCategories,
        isDeleted: isDeleted ?? this.isDeleted,
      );

  @override
  List<Object> get props => [
        category,
        categoryAddStatus,
        categoryAddMessage,
        status,
        message,
        listOfCategories,
        isDeleted,
      ];
}

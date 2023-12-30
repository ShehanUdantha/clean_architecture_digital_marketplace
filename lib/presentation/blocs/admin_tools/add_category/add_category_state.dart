part of 'add_category_bloc.dart';

class AddCategoryState extends Equatable {
  final String category;
  final BlocStatus status;
  final String message;

  const AddCategoryState({
    this.category = '',
    this.status = BlocStatus.initial,
    this.message = '',
  });

  AddCategoryState copyWith({
    String? category,
    BlocStatus? status,
    String? message,
  }) =>
      AddCategoryState(
        category: category ?? this.category,
        status: status ?? this.status,
        message: message ?? this.message,
      );

  @override
  List<Object> get props => [
        category,
        status,
        message,
      ];
}

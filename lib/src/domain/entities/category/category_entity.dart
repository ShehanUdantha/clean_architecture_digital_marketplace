import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final dynamic dateCreated;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.dateCreated,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        dateCreated,
      ];
}

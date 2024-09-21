import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String? id;
  final String title;
  final String description;
  final dynamic dateCreated;

  const NotificationEntity({
    this.id,
    required this.title,
    required this.description,
    this.dateCreated,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dateCreated,
      ];
}

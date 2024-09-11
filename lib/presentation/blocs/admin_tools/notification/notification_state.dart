part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final BlocStatus status;
  final String message;
  final List<NotificationEntity> listOfNotification;
  final bool isDeleted;
  final int notificationCount;

  const NotificationState({
    this.status = BlocStatus.initial,
    this.message = '',
    this.listOfNotification = const [],
    this.isDeleted = false,
    this.notificationCount = -1,
  });

  NotificationState copyWith({
    BlocStatus? status,
    String? message,
    List<NotificationEntity>? listOfNotification,
    bool? isDeleted,
    int? notificationCount,
  }) =>
      NotificationState(
        status: status ?? this.status,
        message: message ?? this.message,
        listOfNotification: listOfNotification ?? this.listOfNotification,
        isDeleted: isDeleted ?? this.isDeleted,
        notificationCount: notificationCount ?? this.notificationCount,
      );

  @override
  List<Object> get props => [
        status,
        message,
        listOfNotification,
        isDeleted,
        notificationCount,
      ];
}

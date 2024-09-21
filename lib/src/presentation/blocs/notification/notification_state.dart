part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final String title;
  final String description;
  final BlocStatus notificationSendStatus;
  final String notificationSendMessage;

  final BlocStatus status;
  final String message;
  final List<NotificationEntity> listOfNotification;
  final bool isDeleted;
  final int notificationCount;

  const NotificationState({
    this.title = '',
    this.description = '',
    this.notificationSendStatus = BlocStatus.initial,
    this.notificationSendMessage = '',
    this.status = BlocStatus.initial,
    this.message = '',
    this.listOfNotification = const [],
    this.isDeleted = false,
    this.notificationCount = -1,
  });

  NotificationState copyWith({
    String? title,
    String? description,
    BlocStatus? notificationSendStatus,
    String? notificationSendMessage,
    BlocStatus? status,
    String? message,
    List<NotificationEntity>? listOfNotification,
    bool? isDeleted,
    int? notificationCount,
  }) =>
      NotificationState(
        title: title ?? this.title,
        description: description ?? this.description,
        notificationSendStatus:
            notificationSendStatus ?? this.notificationSendStatus,
        notificationSendMessage:
            notificationSendMessage ?? this.notificationSendMessage,
        status: status ?? this.status,
        message: message ?? this.message,
        listOfNotification: listOfNotification ?? this.listOfNotification,
        isDeleted: isDeleted ?? this.isDeleted,
        notificationCount: notificationCount ?? this.notificationCount,
      );

  @override
  List<Object> get props => [
        title,
        description,
        notificationSendStatus,
        notificationSendMessage,
        status,
        message,
        listOfNotification,
        isDeleted,
        notificationCount,
      ];
}

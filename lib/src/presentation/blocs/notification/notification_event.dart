// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationSendButtonClickedEvent extends NotificationEvent {
  final String title;
  final String description;
  final String userId;

  const NotificationSendButtonClickedEvent({
    required this.title,
    required this.description,
    required this.userId,
  });
}

class SetNotificationSendStatusToDefault extends NotificationEvent {}

class GetAllNotificationsEvent extends NotificationEvent {}

class NotificationDeleteEvent extends NotificationEvent {
  final String notificationId;
  final String userId;

  const NotificationDeleteEvent({
    required this.notificationId,
    required this.userId,
  });
}

class SetNotificationDeleteStateToDefaultEvent extends NotificationEvent {}

class UpdateNotificationCountEvent extends NotificationEvent {
  final String userId;

  const UpdateNotificationCountEvent({required this.userId});
}

class GetNotificationCountEvent extends NotificationEvent {
  final String userId;

  const GetNotificationCountEvent({required this.userId});
}

class ResetNotificationCountEvent extends NotificationEvent {
  final String userId;

  const ResetNotificationCountEvent({required this.userId});
}

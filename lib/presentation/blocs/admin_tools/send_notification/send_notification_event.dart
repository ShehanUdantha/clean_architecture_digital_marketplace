part of 'send_notification_bloc.dart';

sealed class SendNotificationEvent extends Equatable {
  const SendNotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationSendButtonClickedEvent extends SendNotificationEvent {
  final String title;
  final String description;

  const NotificationSendButtonClickedEvent({
    required this.title,
    required this.description,
  });
}

class SetNotificationStatusToDefault extends SendNotificationEvent {}

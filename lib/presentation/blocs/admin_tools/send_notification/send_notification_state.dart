part of 'send_notification_bloc.dart';

class SendNotificationState extends Equatable {
  final String title;
  final String description;
  final BlocStatus status;
  final String message;

  const SendNotificationState({
    this.title = '',
    this.description = '',
    this.status = BlocStatus.initial,
    this.message = '',
  });

  SendNotificationState copyWith({
    String? title,
    String? description,
    BlocStatus? status,
    String? message,
  }) =>
      SendNotificationState(
        title: title ?? this.title,
        description: description ?? this.description,
        status: status ?? this.status,
        message: message ?? this.message,
      );

  @override
  List<Object> get props => [
        title,
        description,
        status,
        message,
      ];
}

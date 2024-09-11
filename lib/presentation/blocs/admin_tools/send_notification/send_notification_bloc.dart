import 'dart:async';

import '../../../../core/utils/extension.dart';
import '../../../../domain/entities/notification/notification_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enum.dart';
import '../../../../domain/usecases/notification/send_notification_usecase.dart';

part 'send_notification_event.dart';
part 'send_notification_state.dart';

class SendNotificationBloc
    extends Bloc<SendNotificationEvent, SendNotificationState> {
  final SendNotificationUseCase sendNotificationUseCase;

  SendNotificationBloc(this.sendNotificationUseCase)
      : super(const SendNotificationState()) {
    on<NotificationSendButtonClickedEvent>(
        onNotificationSendButtonClickedEvent);
    on<SetNotificationStatusToDefault>(onSetNotificationStatusToDefault);
  }

  FutureOr<void> onNotificationSendButtonClickedEvent(
    NotificationSendButtonClickedEvent event,
    Emitter<SendNotificationState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    NotificationEntity notificationEntity = NotificationEntity(
      title: event.title,
      description: event.description,
    );

    final result = await sendNotificationUseCase.call(notificationEntity);
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: BlocStatus.error,
            message: l.errorMessage,
          ),
        );
      },
      (r) {
        if (r == ResponseTypes.success.response) {
          emit(
            state.copyWith(
              message: r,
              status: BlocStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              message: r,
              status: BlocStatus.error,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onSetNotificationStatusToDefault(
    SetNotificationStatusToDefault event,
    Emitter<SendNotificationState> emit,
  ) {
    emit(state.copyWith(
      status: BlocStatus.initial,
      message: '',
    ));
  }
}

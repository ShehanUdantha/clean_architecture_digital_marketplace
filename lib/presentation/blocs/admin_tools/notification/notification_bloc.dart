import 'dart:async';

import '../../../../domain/usecases/notification/get_notification_count_usecase.dart';
import '../../../../domain/usecases/notification/reset_notification_count_usecase.dart';
import '../../../../domain/usecases/notification/update_notification_count_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/enum.dart';
import '../../../../domain/entities/notification/notification_entity.dart';
import '../../../../domain/usecases/notification/delete_notification_usecase.dart';
import '../../../../domain/usecases/notification/get_all_notifications_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetAllNotificationsUseCase getAllNotificationsUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final UpdateNotificationCountUseCase updateNotificationCountUseCase;
  final GetNotificationCountUseCase getNotificationCountUseCase;
  final ResetNotificationCountUseCase resetNotificationCountUseCase;

  NotificationBloc(
    this.getAllNotificationsUseCase,
    this.deleteNotificationUseCase,
    this.updateNotificationCountUseCase,
    this.getNotificationCountUseCase,
    this.resetNotificationCountUseCase,
  ) : super(const NotificationState()) {
    on<GetAllNotificationsEvent>(onGetAllNotificationsEvent);
    on<NotificationDeleteEvent>(onNotificationDeleteEvent);
    on<SetNotificationDeleteStateToDefaultEvent>(
        onSetNotificationDeleteStateToDefaultEvent);
    on<UpdateNotificationCountEvent>(onUpdateNotificationCountEvent);
    on<GetNotificationCountEvent>(onGetNotificationCountEvent);
    on<ResetNotificationCountEvent>(onResetNotificationCountEvent);
  }

  FutureOr<void> onGetAllNotificationsEvent(
    GetAllNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await getAllNotificationsUseCase.call(NoParams());
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listOfNotification: r,
          status: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onNotificationDeleteEvent(
    NotificationDeleteEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await deleteNotificationUseCase.call(event.id);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          message: r,
          status: BlocStatus.success,
          isDeleted: true,
        ),
      ),
    );
  }

  FutureOr<void> onSetNotificationDeleteStateToDefaultEvent(
    SetNotificationDeleteStateToDefaultEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(isDeleted: false));
  }

  FutureOr<void> onUpdateNotificationCountEvent(
    UpdateNotificationCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await updateNotificationCountUseCase.call(event.userId);
    result.fold((l) {
      debugPrint(l.errorMessage);
    }, (r) => emit(state.copyWith(notificationCount: r)));
  }

  FutureOr<void> onGetNotificationCountEvent(
    GetNotificationCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await getNotificationCountUseCase.call(event.userId);
    result.fold(
      (l) {
        debugPrint(l.errorMessage);
      },
      (r) => emit(state.copyWith(notificationCount: r)),
    );
  }

  FutureOr<void> onResetNotificationCountEvent(
    ResetNotificationCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await resetNotificationCountUseCase.call(event.userId);
    result.fold(
      (l) {
        debugPrint(l.errorMessage);
      },
      (r) => emit(state.copyWith(notificationCount: 0)),
    );
  }
}

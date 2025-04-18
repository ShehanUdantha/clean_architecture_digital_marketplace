import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/notification/delete_notification_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/notification/get_all_notifications_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/notification/get_notification_count_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/notification/reset_notification_count_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/notification/send_notification_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/notification/update_notification_count_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/notification/notification_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/auth_values.dart';
import '../../../fixtures/notification_values.dart';
import 'notification_bloc_test.mocks.dart';

@GenerateMocks([
  SendNotificationUseCase,
  GetAllNotificationsUseCase,
  DeleteNotificationUseCase,
  UpdateNotificationCountUseCase,
  GetNotificationCountUseCase,
  ResetNotificationCountUseCase,
])
void main() {
  late NotificationBloc notificationBloc;
  late MockSendNotificationUseCase mockSendNotificationUseCase;
  late MockGetAllNotificationsUseCase mockGetAllNotificationsUseCase;
  late MockDeleteNotificationUseCase mockDeleteNotificationUseCase;
  late MockUpdateNotificationCountUseCase mockUpdateNotificationCountUseCase;
  late MockGetNotificationCountUseCase mockGetNotificationCountUseCase;
  late MockResetNotificationCountUseCase mockResetNotificationCountUseCase;

  setUp(() {
    mockSendNotificationUseCase = MockSendNotificationUseCase();
    mockGetAllNotificationsUseCase = MockGetAllNotificationsUseCase();
    mockDeleteNotificationUseCase = MockDeleteNotificationUseCase();
    mockUpdateNotificationCountUseCase = MockUpdateNotificationCountUseCase();
    mockGetNotificationCountUseCase = MockGetNotificationCountUseCase();
    mockResetNotificationCountUseCase = MockResetNotificationCountUseCase();
    notificationBloc = NotificationBloc(
      mockSendNotificationUseCase,
      mockGetAllNotificationsUseCase,
      mockDeleteNotificationUseCase,
      mockUpdateNotificationCountUseCase,
      mockGetNotificationCountUseCase,
      mockResetNotificationCountUseCase,
    );
  });

  tearDown(() {
    notificationBloc.close();
  });

  blocTest<NotificationBloc, NotificationState>(
    'emits [loading, success] when NotificationSendButtonClickedEvent is added and use case return success',
    build: () {
      when(mockSendNotificationUseCase.call(notificationEntityToSend))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(
      NotificationSendButtonClickedEvent(
        title: notificationTitleToSend,
        description: notificationDescriptionToSend,
      ),
    ),
    expect: () => [
      NotificationState().copyWith(notificationSendStatus: BlocStatus.loading),
      NotificationState().copyWith(notificationSendStatus: BlocStatus.success),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [loading, error, message] when NotificationSendButtonClickedEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Send notification failed',
      );
      when(mockSendNotificationUseCase.call(notificationEntityToSend))
          .thenAnswer((_) async => Left(failure));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(
      NotificationSendButtonClickedEvent(
        title: notificationTitleToSend,
        description: notificationDescriptionToSend,
      ),
    ),
    expect: () => [
      NotificationState().copyWith(notificationSendStatus: BlocStatus.loading),
      NotificationState().copyWith(
        notificationSendStatus: BlocStatus.error,
        notificationSendMessage: 'Send notification failed',
      ),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits updated state with notificationSendStatus and notificationSendMessage when SetProductFavoriteToDefaultEvent is added',
    build: () => notificationBloc,
    act: (bloc) => bloc.add(SetNotificationSendStatusToDefault()),
    expect: () => [
      NotificationState().copyWith(
        notificationSendStatus: BlocStatus.initial,
        notificationSendMessage: '',
      ),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [loading, success, listOfNotification] when NotificationSendButtonClickedEvent is added and use case return listOfNotification',
    build: () {
      when(mockGetAllNotificationsUseCase.call(any))
          .thenAnswer((_) async => Right(notificationEntities));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(GetAllNotificationsEvent()),
    expect: () => [
      NotificationState().copyWith(status: BlocStatus.loading),
      NotificationState().copyWith(
        status: BlocStatus.success,
        listOfNotification: notificationEntities,
      ),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [loading, error, message] when GetAllNotificationsEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get all notifications failed',
      );
      when(mockGetAllNotificationsUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(GetAllNotificationsEvent()),
    expect: () => [
      NotificationState().copyWith(status: BlocStatus.loading),
      NotificationState().copyWith(
        status: BlocStatus.error,
        message: 'Get all notifications failed',
      ),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [loading, success, isDeleted] when NotificationDeleteEvent is added and use case return success',
    build: () {
      when(mockDeleteNotificationUseCase.call(notificationId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return notificationBloc;
    },
    act: (bloc) =>
        bloc.add(NotificationDeleteEvent(notificationId: notificationId)),
    expect: () => [
      NotificationState().copyWith(status: BlocStatus.loading),
      NotificationState().copyWith(
        status: BlocStatus.success,
        isDeleted: true,
      ),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [loading, error, message] when NotificationDeleteEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Delete notification failed',
      );
      when(mockDeleteNotificationUseCase.call(notificationId))
          .thenAnswer((_) async => Left(failure));

      return notificationBloc;
    },
    act: (bloc) =>
        bloc.add(NotificationDeleteEvent(notificationId: notificationId)),
    expect: () => [
      NotificationState().copyWith(status: BlocStatus.loading),
      NotificationState().copyWith(
        status: BlocStatus.error,
        message: 'Delete notification failed',
      ),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits updated state with isDelete when SetNotificationDeleteStateToDefaultEvent is added',
    build: () => notificationBloc,
    act: (bloc) => bloc.add(SetNotificationDeleteStateToDefaultEvent()),
    expect: () => [
      NotificationState().copyWith(isDeleted: false),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [notificationCount] when UpdateNotificationCountEvent is added and use case return new notification count',
    build: () {
      when(mockUpdateNotificationCountUseCase.call(userUserId))
          .thenAnswer((_) async => Right(currentUserNotificationNewCount));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(UpdateNotificationCountEvent(userId: userUserId)),
    expect: () => [
      NotificationState().copyWith(
        notificationCount: currentUserNotificationNewCount,
      ),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits no state when UpdateNotificationCountEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Update notification count failed',
      );
      when(mockUpdateNotificationCountUseCase.call(userUserId))
          .thenAnswer((_) async => Left(failure));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(UpdateNotificationCountEvent(userId: userUserId)),
    expect: () => [],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [notificationCount] when GetNotificationCountEvent is added and use case return notification count',
    build: () {
      when(mockGetNotificationCountUseCase.call(userUserId))
          .thenAnswer((_) async => Right(currentUserNotificationCount));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(GetNotificationCountEvent(userId: userUserId)),
    expect: () => [
      NotificationState().copyWith(
        notificationCount: currentUserNotificationCount,
      ),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits no state when GetNotificationCountEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get notification count failed',
      );
      when(mockGetNotificationCountUseCase.call(userUserId))
          .thenAnswer((_) async => Left(failure));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(GetNotificationCountEvent(userId: userUserId)),
    expect: () => [],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [notificationCount] when ResetNotificationCountEvent is added and use case return success',
    build: () {
      when(mockResetNotificationCountUseCase.call(userUserId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(ResetNotificationCountEvent(userId: userUserId)),
    expect: () => [
      NotificationState().copyWith(
        notificationCount: 0,
      ),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits no state when ResetNotificationCountEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Reset notification count failed',
      );
      when(mockResetNotificationCountUseCase.call(userUserId))
          .thenAnswer((_) async => Left(failure));

      return notificationBloc;
    },
    act: (bloc) => bloc.add(ResetNotificationCountEvent(userId: userUserId)),
    expect: () => [],
  );
}

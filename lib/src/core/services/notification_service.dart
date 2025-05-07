import 'dart:io';

import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../config/routes/router.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../constants/routes_name.dart';
import '../utils/enum.dart';

@pragma('vm:entry-point')
Future<void> onDidReceiveNotification(
  NotificationResponse notificationResponse,
) async {
  final authState = rootNavigatorKey.currentContext!.read<AuthBloc>().state;

  final payload = notificationResponse.payload;
  if (payload == AppVariableNames.downloadPayload) return;

  goRouter.goNamed(authState.userType == UserTypes.user.name
      ? AppRoutes.notificationViewPageName
      : AppRoutes.notificationAdminViewPageName);
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging firebaseMessaging;

  NotificationService({
    required this.flutterLocalNotificationsPlugin,
    required this.firebaseMessaging,
  });

  void initLocalNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> initFirebaseMessagingListeners() async {
    await firebaseMessaging.requestPermission();

    // terminate
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        updateNotificationCount();
        showInstantNotification(
          title: remoteMessage.notification?.title ?? "",
          body: remoteMessage.notification?.body ?? "",
        );
      }
    });

    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        updateNotificationCount();
        showInstantNotification(
          title: remoteMessage.notification?.title ?? "",
          body: remoteMessage.notification?.body ?? "",
        );
      }
    });

    // background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        showInstantNotification(
          title: remoteMessage.notification?.title ?? "",
          body: remoteMessage.notification?.body ?? "",
        );
      }
    });
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    String payload = 'firebase_messaging',
  }) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_notification_channel_id',
        'Instant Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void updateNotificationCount() {
    final uid =
        rootNavigatorKey.currentContext!.read<AuthBloc>().state.user?.uid ??
            "-1";

    rootNavigatorKey.currentContext!
        .read<NotificationBloc>()
        .add(UpdateNotificationCountEvent(userId: uid));
  }

  Future<void> showProgressNotification({
    required String title,
    required int progress,
    required String fileName,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      importance: Importance.max,
      priority: Priority.high,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      onlyAlertOnce: true,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      '$progress% complete',
      platformChannelSpecifics,
      payload: AppVariableNames.downloadPayload,
    );
  }
}

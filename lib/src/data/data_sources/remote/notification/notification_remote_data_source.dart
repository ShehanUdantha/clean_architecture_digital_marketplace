// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../../../config/routes/router.dart';
import '../../../../core/constants/urls.dart';
import '../../../../core/constants/variable_names.dart';
import '../../../../domain/usecases/notification/delete_notification_params.dart';
import '../../../../domain/usecases/notification/send_notification_params.dart';
import '../../../models/notification/notification_model.dart';
import '../../../../domain/entities/notification/notification_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis_auth/auth_io.dart' as google_auth;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../../core/constants/firebase_values.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/extension.dart';
import '../../../models/user/user_model.dart';

abstract class NotificationRemoteDataSource {
  Future<String> sendNotification(
      SendNotificationParams sendNotificationParams);
  Future<List<NotificationEntity>> getAllNotifications();
  Future<String> deleteNotification(
      DeleteNotificationParams deleteNotificationParams);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final http.Client client;

  NotificationRemoteDataSourceImpl({
    required this.fireStore,
    required this.auth,
    required this.client,
  });

  @override
  Future<String> sendNotification(
      SendNotificationParams sendNotificationParams) async {
    try {
      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(sendNotificationParams.userId)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext!.loc.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        final notificationId = const Uuid().v1();

        await sendNotificationsToAllUsers(sendNotificationParams);

        await fireStore
            .collection(AppVariableNames.notifications)
            .doc(notificationId)
            .set({
          "id": notificationId,
          "title": sendNotificationParams.notification.title,
          "description": sendNotificationParams.notification.description,
          "dateCreated": DateTime.now(),
        });

        return ResponseTypes.success.response;
      } else {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext!.loc.unauthorizedAccess,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on APIException catch (e) {
      throw APIException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String> deleteNotification(
      DeleteNotificationParams deleteNotificationParams) async {
    try {
      final userDoc = await fireStore
          .collection(AppVariableNames.users)
          .doc(deleteNotificationParams.userId)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
            errorMessage: rootNavigatorKey.currentContext!.loc.userNotFound);
      }

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (userModel.userType == UserTypes.admin.name) {
        await fireStore
            .collection(AppVariableNames.notifications)
            .doc(deleteNotificationParams.notificationId)
            .delete();

        return ResponseTypes.success.response;
      } else {
        throw AuthException(
          errorMessage: rootNavigatorKey.currentContext!.loc.unauthorizedAccess,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<NotificationEntity>> getAllNotifications() async {
    try {
      final result =
          await fireStore.collection(AppVariableNames.notifications).get();

      return List<NotificationEntity>.from(
          (result.docs).map((e) => NotificationModel.fromMap(e)));
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<Set<String>> getAllDeviceTokens() async {
    try {
      final result = await fireStore.collection(AppVariableNames.users).get();

      return result.docs
          .map((e) => e.data()['deviceToken'] as String?)
          .where((token) => token != null && token.isNotEmpty)
          .cast<String>()
          .toSet();
    } on FirebaseAuthException catch (e) {
      throw AuthException(errorMessage: e.toString());
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<String> getFirebaseServiceAccessToken() async {
    // ! please update the "firebaseServiceAccountJson" json values
    // core/constants/firebase_values.dart

    try {
      http.Client client = await google_auth.clientViaServiceAccount(
        google_auth.ServiceAccountCredentials.fromJson(
          firebaseServiceAccountJson,
        ),
        firebaseMessagingScope,
      );

      google_auth.AccessCredentials credentials =
          await google_auth.obtainAccessCredentialsViaServiceAccount(
        google_auth.ServiceAccountCredentials.fromJson(
          firebaseServiceAccountJson,
        ),
        firebaseMessagingScope,
        client,
      );

      client.close();

      return credentials.accessToken.data;
    } catch (e, stackTrace) {
      throw DBException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> sendNotificationsToAllUsers(
      SendNotificationParams sendNotificationParams) async {
    try {
      final Set<String> allDeviceTokens = await getAllDeviceTokens();
      final String serviceAccessToken = await getFirebaseServiceAccessToken();

      for (final tokenId in allDeviceTokens) {
        final Map<String, dynamic> message = {
          'message': {
            'token': tokenId,
            'notification': {
              'title': sendNotificationParams.notification.title,
              'body': sendNotificationParams.notification.description,
            },
          },
        };

        final http.Response response = await http.post(
          Uri.parse(AppUrls.firebaseCloudMessagingBaseUrl),
          headers: {
            'Authorization': 'Bearer $serviceAccessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(message),
        );

        if (response.statusCode == 200) {
          debugPrint("Notification send success");
        } else {
          debugPrint("Notification send failed to $tokenId");
        }
      }
    } on AuthException catch (e) {
      throw AuthException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on DBException catch (e) {
      throw DBException(
        errorMessage: e.errorMessage,
        stackTrace: e.stackTrace,
      );
    } on APIException catch (e) {
      throw APIException(
        errorMessage: e.errorMessage.toString(),
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      throw APIException(
        errorMessage: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}

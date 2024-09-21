// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../../../core/constants/urls.dart';
import '../../../../core/constants/variable_names.dart';
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

abstract class NotificationRemoteDataSource {
  Future<String> sendNotification(NotificationEntity notification);
  Future<List<NotificationEntity>> getAllNotifications();
  Future<String> deleteNotification(String productId);
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
  Future<String> sendNotification(NotificationEntity notification) async {
    try {
      final notificationId = const Uuid().v1();

      await sendNotificationsToAllUsers(notification);

      await fireStore
          .collection(AppVariableNames.notifications)
          .doc(notificationId)
          .set({
        "id": notificationId,
        "title": notification.title,
        "description": notification.description,
        "dateCreated": DateTime.now(),
      });

      return ResponseTypes.success.response;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    } on APIException catch (e) {
      throw APIException(errorMessage: e.errorMessage.toString());
    }
  }

  @override
  Future<String> deleteNotification(String notificationId) async {
    try {
      await fireStore
          .collection(AppVariableNames.notifications)
          .doc(notificationId)
          .delete();

      return ResponseTypes.success.response;
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<NotificationEntity>> getAllNotifications() async {
    try {
      final result =
          await fireStore.collection(AppVariableNames.notifications).get();

      return List<NotificationEntity>.from(
          (result.docs).map((e) => NotificationModel.fromMap(e)));
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
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
    } on FirebaseException catch (e) {
      throw DBException(errorMessage: e.toString());
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
    } catch (e) {
      throw APIException(errorMessage: e.toString());
    }
  }

  Future<void> sendNotificationsToAllUsers(
      NotificationEntity notification) async {
    try {
      final Set<String> allDeviceTokens = await getAllDeviceTokens();
      final String serviceAccessToken = await getFirebaseServiceAccessToken();

      for (final tokenId in allDeviceTokens) {
        final Map<String, dynamic> message = {
          'message': {
            'token': tokenId,
            'notification': {
              'title': notification.title,
              'body': notification.description,
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
    } on APIException catch (e) {
      throw APIException(errorMessage: e.errorMessage.toString());
    } catch (e) {
      throw APIException(errorMessage: e.toString());
    }
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/extension.dart';

abstract class NotificationLocalDataSource {
  Future<int> updateNotificationCount(String userId);
  Future<int> getNotificationCount(String userId);
  Future<String> resetNotificationCount(String userId);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final Box<dynamic> notificationBox;

  NotificationLocalDataSourceImpl({required this.notificationBox});

  @override
  Future<int> getNotificationCount(String userId) async {
    try {
      final int? count = await notificationBox.get(
        userId,
      );

      return count ?? 0;
    } on HiveError catch (e) {
      throw DBException(errorMessage: e.toString());
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
  Future<String> resetNotificationCount(String userId) async {
    try {
      await notificationBox.put(
        userId,
        0,
      );

      return ResponseTypes.success.response;
    } on HiveError catch (e) {
      throw DBException(errorMessage: e.toString());
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
  Future<int> updateNotificationCount(String userId) async {
    try {
      final int? previousCount = await notificationBox.get(userId);

      final int newCount = (previousCount ?? 0) + 1;

      await notificationBox.put(
        userId,
        newCount,
      );

      return newCount;
    } on HiveError catch (e) {
      throw DBException(errorMessage: e.toString());
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
}

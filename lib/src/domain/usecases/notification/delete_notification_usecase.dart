import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/notification/notification_repository.dart';
import 'delete_notification_params.dart';

class DeleteNotificationUseCase
    extends UseCase<String, DeleteNotificationParams> {
  final NotificationRepository notificationRepository;

  DeleteNotificationUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, String>> call(DeleteNotificationParams params) async {
    return await notificationRepository.deleteNotification(params);
  }
}

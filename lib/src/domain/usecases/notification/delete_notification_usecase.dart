import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/notification/notification_repository.dart';

class DeleteNotificationUseCase extends UseCase<String, String> {
  final NotificationRepository notificationRepository;

  DeleteNotificationUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await notificationRepository.deleteNotification(params);
  }
}

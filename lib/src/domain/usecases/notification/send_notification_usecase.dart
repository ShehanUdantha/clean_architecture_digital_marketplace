import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/notification/notification_repository.dart';
import 'send_notification_params.dart';

class SendNotificationUseCase extends UseCase<String, SendNotificationParams> {
  final NotificationRepository notificationRepository;

  SendNotificationUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, String>> call(SendNotificationParams params) async {
    return await notificationRepository.sendNotification(params);
  }
}

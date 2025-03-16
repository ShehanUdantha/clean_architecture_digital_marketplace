import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/notification/notification_entity.dart';
import '../../repositories/notification/notification_repository.dart';

class SendNotificationUseCase extends UseCase<String, NotificationEntity> {
  final NotificationRepository notificationRepository;

  SendNotificationUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, String>> call(NotificationEntity params) async {
    return await notificationRepository.sendNotification(params);
  }
}

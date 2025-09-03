import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/notification/notification_entity.dart';
import '../../repositories/notification/notification_repository.dart';

class GetAllNotificationsUseCase
    extends UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository notificationRepository;

  GetAllNotificationsUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
      NoParams params) async {
    return await notificationRepository.getAllNotifications();
  }
}

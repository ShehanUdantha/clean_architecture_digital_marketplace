import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/notification/notification_count_repository.dart';

class UpdateNotificationCountUseCase extends UseCase<int, String> {
  final NotificationCountRepository notificationCountRepository;

  UpdateNotificationCountUseCase({required this.notificationCountRepository});

  @override
  Future<Either<Failure, int>> call(String params) async {
    return await notificationCountRepository.updateNotificationCount(params);
  }
}

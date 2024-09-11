import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/notification/notification_count_repository.dart';

class ResetNotificationCountUseCase extends UseCase<String, String> {
  final NotificationCountRepository notificationCountRepository;

  ResetNotificationCountUseCase({required this.notificationCountRepository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await notificationCountRepository.resetNotificationCount(params);
  }
}

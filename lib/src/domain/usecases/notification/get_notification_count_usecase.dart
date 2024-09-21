import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/notification/notification_count_repository.dart';

class GetNotificationCountUseCase extends UseCase<int, String> {
  final NotificationCountRepository notificationCountRepository;

  GetNotificationCountUseCase({required this.notificationCountRepository});

  @override
  Future<Either<Failure, int>> call(String params) async {
    return await notificationCountRepository.getNotificationCount(params);
  }
}

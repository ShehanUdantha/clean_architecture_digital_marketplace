// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/strings.dart';
import '../../../core/utils/enum.dart';
import '../../../core/widgets/notification_linear_card_widget.dart';
import '../../blocs/admin_tools/notification/notification_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';

class NotificationListBuilderWidget extends StatelessWidget {
  final bool isHide;

  const NotificationListBuilderWidget({
    super.key,
    this.isHide = false,
  });

  @override
  Widget build(BuildContext context) {
    final notificationState = context.watch<NotificationBloc>().state;
    final authState = context.watch<AuthBloc>().state;

    return Expanded(
      child: notificationState.listOfNotification.isNotEmpty
          ? ListView.builder(
              itemCount: notificationState.listOfNotification.length,
              itemBuilder: (context, index) {
                return NotificationLinearCardWidget(
                  notification: notificationState.listOfNotification[index],
                  deleteFunction: isHide
                      ? null
                      : authState.userType == UserTypes.user.name
                          ? null
                          : () => _handleDeleteNotification(
                                context,
                                notificationState.listOfNotification[index].id!,
                              ),
                );
              },
            )
          : const Center(
              child: Text(AppStrings.productsNotAddedYet),
            ),
    );
  }

  _handleDeleteNotification(
    BuildContext context,
    String id,
  ) {
    context.read<NotificationBloc>().add(NotificationDeleteEvent(id: id));
    context.read<NotificationBloc>().add(GetAllNotificationsEvent());
  }
}
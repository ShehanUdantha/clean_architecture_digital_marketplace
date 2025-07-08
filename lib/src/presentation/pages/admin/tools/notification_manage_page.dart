import '../../../../core/utils/extension.dart';

import '../../../../core/widgets/linear_loading_indicator.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../widgets/notification/notification_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/routes_name.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/page_header_widget.dart';
import '../../../widgets/admin/tools/floating_button_widget.dart';

class NotificationManagePage extends StatelessWidget {
  const NotificationManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
      floatingActionButton: FloatingButtonWidget(
        function: () => _handleFloatingButton(context),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: Column(
          children: [
            PageHeaderWidget(
              title: context.loc.manageNotifications,
              function: () => _handleBackButton(context),
            ),
            const SizedBox(
              height: 26.0,
            ),
            BlocConsumer<NotificationBloc, NotificationState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.isDeleted != current.isDeleted,
              listener: (context, state) {
                if (state.status == BlocStatus.error) {
                  Helper.showSnackBar(
                    context,
                    state.message,
                  );
                }
                if (state.isDeleted && state.status == BlocStatus.success) {
                  context
                      .read<NotificationBloc>()
                      .add(SetNotificationDeleteStateToDefaultEvent());

                  Helper.showSnackBar(
                    context,
                    context.loc.notificationDeleted,
                  );

                  context
                      .read<NotificationBloc>()
                      .add(GetAllNotificationsEvent());
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case BlocStatus.loading:
                    return const LinearLoadingIndicator();
                  case BlocStatus.success:
                    return const NotificationListBuilderWidget();
                  case BlocStatus.error:
                    return Center(
                      child: Text(state.message),
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackButton(BuildContext context) {
    context.goNamed(AppRoutes.toolsPageName);
  }

  void _handleFloatingButton(BuildContext context) {
    context.goNamed(AppRoutes.notificationSendPageName);
  }
}

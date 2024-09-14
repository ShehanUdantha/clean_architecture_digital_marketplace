import '../../../blocs/notification/notification_bloc.dart';
import '../../../widgets/notification/notification_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/routes_name.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/page_header_widget.dart';
import '../../../widgets/admin/tools/floating_button_widget.dart';

class NotificationManagePage extends StatefulWidget {
  const NotificationManagePage({super.key});

  @override
  State<NotificationManagePage> createState() => _NotificationManagePageState();
}

class _NotificationManagePageState extends State<NotificationManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        function: () => _handleFloatingButton(context),
      ),
    );
  }

  _bodyWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: Column(
          children: [
            PageHeaderWidget(
              title: 'Manage Notifications',
              function: () => _handleBackButton(),
            ),
            const SizedBox(
              height: 26,
            ),
            BlocConsumer<NotificationBloc, NotificationState>(
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
                    AppStrings.notificationDeleted,
                  );
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case BlocStatus.loading:
                    return const Center(
                      child: LinearProgressIndicator(
                        color: AppColors.secondary,
                      ),
                    );
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

  _handleBackButton() {
    context.goNamed(AppRoutes.toolsPageName);
  }

  _handleFloatingButton(BuildContext context) {
    context.goNamed(AppRoutes.notificationSendPageName);
  }
}

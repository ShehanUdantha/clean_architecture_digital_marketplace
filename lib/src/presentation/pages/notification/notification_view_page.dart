import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/page_header_widget.dart';
import '../../../core/widgets/linear_loading_indicator.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/notification/notification_list_builder_widget.dart';

class NotificationViewPage extends StatefulWidget {
  const NotificationViewPage({super.key});

  @override
  State<NotificationViewPage> createState() => _NotificationViewPageState();
}

class _NotificationViewPageState extends State<NotificationViewPage> {
  @override
  void initState() {
    final getCurrentUserId = context.read<AuthBloc>().currentUserId ?? "-1";
    context
        .read<NotificationBloc>()
        .add(ResetNotificationCountEvent(userId: getCurrentUserId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: Column(
          children: [
            PageHeaderWidget(
              title: context.loc.notifications,
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
                    context.loc.notificationDeleted,
                  );
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case BlocStatus.loading:
                    return const LinearLoadingIndicator();
                  case BlocStatus.success:
                    return const NotificationListBuilderWidget(
                      isHide: true,
                    );
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

  void _handleBackButton() {
    final authState = context.read<AuthBloc>().state;
    context.goNamed(authState.userType == UserTypes.user.name
        ? AppRoutes.homePageName
        : AppRoutes.adminPageName);
  }
}

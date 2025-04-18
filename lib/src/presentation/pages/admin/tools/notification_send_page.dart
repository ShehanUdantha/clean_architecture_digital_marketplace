import '../../../../core/utils/extension.dart';

import '../../../blocs/notification/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/routes_name.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/elevated_button_widget.dart';
import '../../../../core/widgets/elevated_loading_button_widget.dart';
import '../../../../core/widgets/input_field_widget.dart';
import '../../../../core/widgets/page_header_widget.dart';

class NotificationSendPage extends StatefulWidget {
  const NotificationSendPage({super.key});

  @override
  State<NotificationSendPage> createState() => _NotificationSendPageState();
}

class _NotificationSendPageState extends State<NotificationSendPage> {
  final TextEditingController _notificationTitleController =
      TextEditingController();
  final TextEditingController _notificationDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    _notificationTitleController.dispose();
    _notificationDescriptionController.dispose();
    super.dispose();
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
        child: SingleChildScrollView(
          child: BlocConsumer<NotificationBloc, NotificationState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.notificationSendStatus == BlocStatus.error) {
                context
                    .read<NotificationBloc>()
                    .add(SetNotificationSendStatusToDefault());

                Helper.showSnackBar(
                  context,
                  state.notificationSendMessage,
                );
              }
              if (state.notificationSendStatus == BlocStatus.success) {
                context
                    .read<NotificationBloc>()
                    .add(SetNotificationSendStatusToDefault());

                Helper.showSnackBar(
                  context,
                  context.loc.notificationSend,
                );

                context
                    .read<NotificationBloc>()
                    .add(GetAllNotificationsEvent());

                context.goNamed(AppRoutes.notificationManagePageName);
              }
            },
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageHeaderWidget(
                    title: context.loc.sendNotification,
                    function: () => _handleBackButton(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputFieldWidget(
                          controller: _notificationTitleController,
                          hint: context.loc.title,
                          prefix: const Icon(Iconsax.notification),
                          isReadOnly: state.status == BlocStatus.loading,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        InputFieldWidget(
                          controller: _notificationDescriptionController,
                          hint: context.loc.description,
                          prefix: const Icon(Iconsax.text_block),
                          isTextArea: true,
                          isReadOnly: state.status == BlocStatus.loading,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  state.status == BlocStatus.loading
                      ? const ElevatedLoadingButtonWidget()
                      : ElevatedButtonWidget(
                          title: context.loc.sendNotification,
                          function: () => _handleSubmitButton(),
                        ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleBackButton() {
    context.goNamed(AppRoutes.notificationManagePageName);
  }

  void _handleSubmitButton() async {
    if (_notificationTitleController.text.isNotEmpty) {
      if (_notificationDescriptionController.text.isNotEmpty) {
        context.read<NotificationBloc>().add(
              NotificationSendButtonClickedEvent(
                title: _notificationTitleController.text,
                description: _notificationDescriptionController.text,
              ),
            );
      } else {
        Helper.showSnackBar(context, context.loc.requiredDescription);
      }
    } else {
      Helper.showSnackBar(context, context.loc.requiredTitle);
    }
  }
}

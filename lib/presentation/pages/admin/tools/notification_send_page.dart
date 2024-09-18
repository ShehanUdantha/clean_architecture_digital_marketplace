import '../../../blocs/notification/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/routes_name.dart';
import '../../../../core/constants/strings.dart';
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

  _bodyWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeaderWidget(
                title: 'Send Notification',
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
                      hint: 'Title',
                      prefix: const Icon(Iconsax.notification),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFieldWidget(
                      controller: _notificationDescriptionController,
                      hint: 'Description',
                      prefix: const Icon(Iconsax.text_block),
                      isTextArea: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              BlocConsumer<NotificationBloc, NotificationState>(
                listener: (context, state) {
                  if (state.notificationSendStatus == BlocStatus.error) {
                    context
                        .read<NotificationBloc>()
                        .add(SetNotificationSendStatusToDefault());
                    print(state.notificationSendMessage);
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
                      AppStrings.notificationSend,
                    );

                    context
                        .read<NotificationBloc>()
                        .add(GetAllNotificationsEvent());

                    context.goNamed(AppRoutes.notificationManagePageName);
                  }
                },
                builder: (context, state) {
                  if (state.notificationSendStatus == BlocStatus.loading) {
                    return const ElevatedLoadingButtonWidget();
                  }
                  return ElevatedButtonWidget(
                    title: 'Send Notification',
                    function: () => _handleSubmitButton(),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleBackButton() {
    context.goNamed(AppRoutes.notificationManagePageName);
  }

  _handleSubmitButton() async {
    if (_notificationTitleController.text.isNotEmpty) {
      if (_notificationDescriptionController.text.isNotEmpty) {
        context.read<NotificationBloc>().add(
              NotificationSendButtonClickedEvent(
                title: _notificationTitleController.text,
                description: _notificationDescriptionController.text,
              ),
            );
      } else {
        Helper.showSnackBar(context, AppStrings.requiredDescription);
      }
    } else {
      Helper.showSnackBar(context, AppStrings.requiredNotificationTitle);
    }
  }
}

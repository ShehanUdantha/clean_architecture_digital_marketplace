import '../utils/extension.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../constants/routes_name.dart';
import '../utils/enum.dart';
import 'base_icon_button_widget.dart';
import '../constants/colors.dart';
import '../utils/helper.dart';

class MainHeaderWidget extends StatelessWidget {
  final String userName;

  const MainHeaderWidget({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return SizedBox(
      height: Helper.isLandscape(context)
          ? Helper.screeHeight(context) * 0.18
          : Helper.screeHeight(context) * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                '${context.loc.hello}, ${context.loc.welcome} 👋',
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                  fontSize: 16,
                  height: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: Helper.screeWidth(context) * 0.6,
                child: Text(
                  userName,
                  style: TextStyle(
                    color:
                        isDarkMode ? AppColors.textWhite : AppColors.textBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              return BaseIconButtonWidget(
                function: () => _handleViewNotificationPage(context),
                isNotify: state.notificationCount > 0,
                icon: const Icon(
                  Iconsax.notification,
                  color: AppColors.secondary,
                ),
              );
            },
            buildWhen: (previousState, currentState) =>
                previousState.notificationCount !=
                currentState.notificationCount,
          ),
        ],
      ),
    );
  }

  _handleViewNotificationPage(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    context.goNamed(authState.userType == UserTypes.user.name
        ? AppRoutes.notificationViewPageName
        : AppRoutes.notificationAdminViewPageName);
  }
}

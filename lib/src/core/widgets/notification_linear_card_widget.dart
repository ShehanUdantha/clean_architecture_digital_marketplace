import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification/notification_entity.dart';

import 'base_icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';
import '../utils/helper.dart';

class NotificationLinearCardWidget extends StatelessWidget {
  final Function? deleteFunction;
  final NotificationEntity notification;

  const NotificationLinearCardWidget({
    super.key,
    this.deleteFunction,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = Helper.checkIsDarkMode(context, state.themeMode);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.textWhite : AppColors.textFourth,
                fontSize: 15,
              ),
              maxLines: Helper.isLandscape(context) ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (deleteFunction != null)
              Text(
                Helper.formatDate(notification.dateCreated.toDate()),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              notification.description,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.textThird,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 5.0,
            ),
            if (deleteFunction != null)
              Align(
                alignment: Alignment.bottomRight,
                child: BaseIconButtonWidget(
                  function: () => deleteFunction!(),
                  icon: const Icon(
                    Iconsax.bag,
                    size: 18,
                    color: AppColors.lightRed,
                  ),
                  size: 35.0,
                ),
              ),
            if (deleteFunction == null)
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  Helper.formatTimeago(notification.dateCreated.toDate()),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const Divider(
              color: AppColors.lightGrey,
            ),
          ],
        );
      },
    );
  }
}

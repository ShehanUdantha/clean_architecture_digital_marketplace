import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
              const Text(
                'Hello, Welcome 👋',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  height: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: Helper.screeWidth(context) * 0.6,
                child: Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          BaseIconButtonWidget(
            function: () {},
            isNotify: true,
            icon: const Icon(
              Iconsax.notification,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/base_icon_button_widget.dart';
import '../../blocs/theme/theme_bloc.dart';

class ProfileCardWidget extends StatelessWidget {
  final String title;
  final Function function;

  const ProfileCardWidget({
    super.key,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return GestureDetector(
      onTap: () => function(),
      child: Container(
        padding: const EdgeInsets.all(8.0).copyWith(left: 12.0),
        height: Helper.isLandscape(context)
            ? Helper.screeHeight(context) * 0.18
            : Helper.screeHeight(context) * 0.085,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: AppColors.lightDark,
            width: 1.3,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Helper.screeWidth(context) * 0.45,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: BaseIconButtonWidget(
                function: () => function(),
                icon: const Icon(
                  Iconsax.arrow_right_1,
                  color: AppColors.primary,
                ),
                bgColor: AppColors.mediumGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/widgets/base_icon_button_widget.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helper.dart';
import '../../../blocs/theme/theme_bloc.dart';

class ToolsCardWidget extends StatelessWidget {
  final String title;
  final String image;
  final Function function;

  const ToolsCardWidget({
    super.key,
    required this.title,
    required this.image,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return GestureDetector(
      onTap: () => function(),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: Helper.isLandscape(context)
            ? Helper.screeHeight(context) * 0.26
            : Helper.screeHeight(context) * 0.125,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.secondWhite : AppColors.lightDark,
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage(image),
                  height: Helper.screeHeight(context),
                  width: Helper.isLandscape(context)
                      ? Helper.screeWidth(context) * 0.25
                      : Helper.screeWidth(context) * 0.28,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                SizedBox(
                  width: Helper.screeWidth(context) * 0.45,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 5,
              top: 20,
              child: Transform.scale(
                scale: 0.8,
                child: BaseIconButtonWidget(
                  function: () => function(),
                  icon: const Icon(
                    Iconsax.arrow_right_1,
                    color: AppColors.primary,
                  ),
                  bgColor: AppColors.mediumGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

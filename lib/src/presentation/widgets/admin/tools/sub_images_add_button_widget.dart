import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helper.dart';

class SubImagesAddButtonWidget extends StatelessWidget {
  const SubImagesAddButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, themeState) {
        final isDarkMode =
            Helper.checkIsDarkMode(context, themeState.themeMode);

        return Container(
          height: Helper.screeHeight(context),
          width: Helper.isLandscape(context)
              ? Helper.screeWidth(context) * 0.1
              : Helper.screeWidth(context) * 0.2,
          decoration: const BoxDecoration(
            color: AppColors.lightDark,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Center(
            child: Icon(
              Iconsax.add,
              color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
              size: 32,
            ),
          ),
        );
      },
    );
  }
}

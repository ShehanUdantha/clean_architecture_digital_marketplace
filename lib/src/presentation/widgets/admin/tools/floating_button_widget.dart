import 'package:Pixelcart/src/core/utils/helper.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/colors.dart';

class FloatingButtonWidget extends StatelessWidget {
  final Function function;

  const FloatingButtonWidget({
    super.key,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, themeState) {
        final isDarkMode =
            Helper.checkIsDarkMode(context, themeState.themeMode);

        return FloatingActionButton(
          onPressed: () => function(),
          backgroundColor:
              isDarkMode ? AppColors.lightGrey : AppColors.secondary,
          child: Icon(
            Iconsax.add,
            color: isDarkMode ? AppColors.textPrimary : AppColors.textFifth,
          ),
        );
      },
    );
  }
}

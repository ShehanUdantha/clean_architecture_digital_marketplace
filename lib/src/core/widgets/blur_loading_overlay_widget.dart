import 'dart:ui';

import 'package:Pixelcart/src/core/constants/colors.dart';
import 'package:Pixelcart/src/core/utils/helper.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlurLoadingOverlayWidget extends StatelessWidget {
  const BlurLoadingOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = Helper.checkIsDarkMode(context, state.themeMode);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: isDarkMode
                  ? AppColors.textFifth.withValues(alpha: 0.2)
                  : AppColors.textPrimary.withValues(alpha: 0.2),
              child: Center(
                child: CircularProgressIndicator(
                  color:
                      isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
                  strokeWidth: 4.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

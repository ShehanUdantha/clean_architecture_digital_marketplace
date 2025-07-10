// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/core/utils/helper.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/colors.dart';

class CircularLoadingIndicator extends StatelessWidget {
  final double strokeWidth;
  final bool isButtonLoading;

  const CircularLoadingIndicator({
    super.key,
    this.strokeWidth = 4.0,
    this.isButtonLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = Helper.checkIsDarkMode(context, state.themeMode);

        return Center(
          child: CircularProgressIndicator(
            color: isButtonLoading
                ? isDarkMode
                    ? AppColors.textPrimary
                    : AppColors.textFifth
                : isDarkMode
                    ? AppColors.textFifth
                    : AppColors.textPrimary,
            strokeWidth: strokeWidth,
          ),
        );
      },
    );
  }
}

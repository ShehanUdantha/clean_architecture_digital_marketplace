import 'package:Pixelcart/src/core/utils/helper.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/colors.dart';
import 'package:flutter/material.dart';

class InputFieldTitleWidget extends StatelessWidget {
  final String title;

  const InputFieldTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = Helper.checkIsDarkMode(context, state.themeMode);

        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AppColors.textSecondary
                  : AppColors.textPrimary.withValues(alpha: 0.8),
            ),
          ),
        );
      },
    );
  }
}

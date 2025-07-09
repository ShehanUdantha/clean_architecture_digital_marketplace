import '../../presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/colors.dart';
import '../utils/helper.dart';

class AppBarTitleWidget extends StatelessWidget {
  final String title;

  const AppBarTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = Helper.checkIsDarkMode(context, state.themeMode);

        return SizedBox(
          height: Helper.isLandscape(context)
              ? Helper.screeHeight(context) * 0.15
              : Helper.screeHeight(context) * 0.065,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
            ),
          ),
        );
      },
    );
  }
}

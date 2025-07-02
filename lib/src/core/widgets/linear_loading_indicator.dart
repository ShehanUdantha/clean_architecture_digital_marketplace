// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/core/utils/helper.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/colors.dart';

class LinearLoadingIndicator extends StatelessWidget {
  final double? minHeight;

  const LinearLoadingIndicator({
    super.key,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = Helper.checkIsDarkMode(context, state.themeMode);

        return Center(
          child: LinearProgressIndicator(
            color: isDarkMode ? AppColors.primary : AppColors.secondary,
            minHeight: minHeight,
          ),
        );
      },
    );
  }
}

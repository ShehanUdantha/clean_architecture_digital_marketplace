// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/core/constants/colors.dart';
import 'package:Pixelcart/src/core/utils/helper.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemNotFoundText extends StatelessWidget {
  final String title;

  const ItemNotFoundText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = Helper.checkIsDarkMode(context, state.themeMode);

        return Center(
          child: Text(
            title,
            style: TextStyle(
              color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
            ),
          ),
        );
      },
    );
  }
}

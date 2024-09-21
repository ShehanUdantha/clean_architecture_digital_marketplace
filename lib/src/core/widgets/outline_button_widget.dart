import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';
import '../constants/colors.dart';

class OutlineButtonWidget extends StatelessWidget {
  final String title;
  final Function function;

  const OutlineButtonWidget({
    super.key,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return OutlinedButton(
      onPressed: () => function(),
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.secondary,
        side: const BorderSide(color: AppColors.lightGrey),
        textStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.secondary,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.all(20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

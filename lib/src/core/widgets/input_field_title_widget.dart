import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/colors.dart';
import 'package:flutter/material.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';

class InputFieldTitleWidget extends StatelessWidget {
  final String title;

  const InputFieldTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDarkMode
              ? AppColors.textSecondary
              : AppColors.textPrimary.withOpacity(0.8),
        ),
      ),
    );
  }
}

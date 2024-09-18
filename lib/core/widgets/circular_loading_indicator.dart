// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';
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
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

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
  }
}

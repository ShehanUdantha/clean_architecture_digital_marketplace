// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';
import '../constants/colors.dart';

class LinearLoadingIndicator extends StatelessWidget {
  final double? minHeight;

  const LinearLoadingIndicator({
    super.key,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Center(
      child: LinearProgressIndicator(
        color: isDarkMode ? AppColors.primary : AppColors.secondary,
        minHeight: minHeight,
      ),
    );
  }
}

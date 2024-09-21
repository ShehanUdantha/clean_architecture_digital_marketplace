import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';
import '../constants/colors.dart';

class LinearLoadingIndicator extends StatelessWidget {
  const LinearLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Center(
      child: LinearProgressIndicator(
        color: isDarkMode ? AppColors.primary : AppColors.secondary,
      ),
    );
  }
}

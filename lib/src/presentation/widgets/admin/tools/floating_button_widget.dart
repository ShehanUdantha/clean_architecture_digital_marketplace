import '../../../blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/colors.dart';

class FloatingButtonWidget extends StatelessWidget {
  final Function function;

  const FloatingButtonWidget({
    super.key,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return FloatingActionButton(
      onPressed: () => function(),
      backgroundColor: isDarkMode ? AppColors.lightGrey : AppColors.secondary,
      child: Icon(
        Iconsax.add,
        color: isDarkMode ? AppColors.textPrimary : AppColors.textFifth,
      ),
    );
  }
}

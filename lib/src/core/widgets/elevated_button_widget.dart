import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';
import '../constants/colors.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String? title;
  final Widget? actionChild;
  final Function? function;
  final double radius;

  const ElevatedButtonWidget({
    super.key,
    this.title,
    this.actionChild,
    this.function,
    this.radius = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return ElevatedButton(
      onPressed: () => function != null ? function!() : () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: isDarkMode ? AppColors.lightDark : AppColors.lightGrey,
        backgroundColor: isDarkMode ? AppColors.primary : AppColors.secondary,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: isDarkMode ? AppColors.textPrimary : AppColors.textFifth,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          : actionChild ?? const SizedBox(),
    );
  }
}

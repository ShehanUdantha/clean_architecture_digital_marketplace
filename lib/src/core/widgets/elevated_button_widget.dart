import '../utils/helper.dart';
import 'circular_loading_indicator.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/colors.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String? title;
  final Widget? actionChild;
  final Function? function;
  final double radius;
  final bool isButtonLoading;

  const ElevatedButtonWidget({
    super.key,
    this.title,
    this.actionChild,
    this.function,
    this.radius = 40.0,
    this.isButtonLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = Helper.checkIsDarkMode(context, state.themeMode);

        return ElevatedButton(
          onPressed: () => function != null ? function!() : () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor:
                isDarkMode ? AppColors.lightDark : AppColors.lightGrey,
            backgroundColor:
                isDarkMode ? AppColors.primary : AppColors.secondary,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: isButtonLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularLoadingIndicator(
                    strokeWidth: 2.0,
                    isButtonLoading: true,
                  ),
                )
              : title != null
                  ? Text(
                      title!,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.textPrimary
                            : AppColors.textFifth,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : actionChild ?? const SizedBox(),
        );
      },
    );
  }
}

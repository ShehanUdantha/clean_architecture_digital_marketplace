import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/lists.dart';
import '../../blocs/theme/theme_bloc.dart';

class ThemeListView extends StatelessWidget {
  const ThemeListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(top: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.loc.selectYourPreferredTheme,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16.0),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: AppLists.themes.length,
                itemBuilder: (context, index) {
                  final themeName = AppLists.themes.keys.elementAt(index);
                  final themeMode = AppLists.themes.values.elementAt(index);

                  return ListTile(
                    onTap: () {
                      if (themeMode != state.themeMode) {
                        context.read<ThemeBloc>().add(
                              UpdateThemeMode(
                                themeName: themeName,
                                themeMode: themeMode,
                              ),
                            );

                        Future.delayed(const Duration(seconds: 1)).then(
                          (value) {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      }
                    },
                    title: Text(
                      themeName,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppColors.textSecondary
                            : AppColors.textPrimary.withOpacity(0.8),
                      ),
                    ),
                    trailing: themeMode == state.themeMode
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: isDarkMode
                                ? AppColors.textFifth
                                : AppColors.textPrimary,
                          )
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: themeMode == state.themeMode
                          ? BorderSide(
                              width: 1.5,
                              color: isDarkMode
                                  ? AppColors.lightGrey
                                  : AppColors.darkPrimary,
                            )
                          : const BorderSide(
                              color: AppColors.lightDark,
                            ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

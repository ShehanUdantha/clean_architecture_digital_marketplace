import '../../../../core/utils/helper.dart';
import '../../../blocs/language/language_cubit.dart';
import '../../../blocs/theme/theme_cubit.dart';

import '../../../../core/constants/lists.dart';
import '../../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';

class LanguageListView extends StatelessWidget {
  const LanguageListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, themeState) {
        final isDarkMode =
            Helper.checkIsDarkMode(context, themeState.themeMode);

        return Padding(
          padding: const EdgeInsets.all(16.0).copyWith(top: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.loc.selectYourPreferredLanguage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color:
                      isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<LanguageCubit, LanguageState>(
                buildWhen: (previous, current) =>
                    previous.languageLocale != current.languageLocale,
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: AppLists.languages.length,
                    itemBuilder: (context, index) {
                      final languageName =
                          AppLists.languages.keys.elementAt(index);
                      final languageLocale =
                          AppLists.languages.values.elementAt(index);

                      return ListTile(
                        onTap: () => languageLocale != state.languageLocale
                            ? _updateLanguage(
                                context, languageName, languageLocale)
                            : () {},
                        title: Text(
                          languageName,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? AppColors.textSecondary
                                : AppColors.textPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                        trailing: languageLocale == state.languageLocale
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: isDarkMode
                                    ? AppColors.textFifth
                                    : AppColors.textPrimary,
                              )
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: languageLocale == state.languageLocale
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
                      return const SizedBox(height: 16.0);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateLanguage(
    BuildContext context,
    String languageName,
    Locale languageLocale,
  ) {
    context.read<LanguageCubit>().updateLanguage(
          languageName,
          languageLocale,
        );

    Future.delayed(const Duration(milliseconds: 500)).then(
      (value) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

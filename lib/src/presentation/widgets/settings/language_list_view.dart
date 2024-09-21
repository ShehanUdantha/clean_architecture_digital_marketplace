import '../../../core/constants/lists.dart';
import '../../../core/utils/extension.dart';
import '../../blocs/language/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../blocs/theme/theme_bloc.dart';

class LanguageListView extends StatelessWidget {
  const LanguageListView({
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
            context.loc.selectYourPreferredLanguage,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16.0),
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: AppLists.languages.length,
                itemBuilder: (context, index) {
                  final languageName = AppLists.languages.keys.elementAt(index);
                  final languageLocale =
                      AppLists.languages.values.elementAt(index);

                  return ListTile(
                    onTap: () {
                      if (languageLocale != state.languageLocale) {
                        context.read<LanguageBloc>().add(
                              UpdateLanguage(
                                languageName: languageName,
                                languageLocale: languageLocale,
                              ),
                            );

                        Future.delayed(const Duration(milliseconds: 500)).then(
                          (value) {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      }
                    },
                    title: Text(
                      languageName,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppColors.textSecondary
                            : AppColors.textPrimary.withOpacity(0.8),
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

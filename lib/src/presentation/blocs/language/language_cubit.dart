import 'dart:ui';

import '../../../core/constants/lists.dart';
import '../../../core/constants/variable_names.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final SharedPreferences sharedPreferences;

  LanguageCubit(this.sharedPreferences) : super(const LanguageState()) {
    getCurrentLanguage();
  }

  void updateLanguage(String languageName, Locale languageLocale) async {
    await sharedPreferences.setString(
      AppVariableNames.currentLanguage,
      languageName,
    );

    emit(
      state.copyWith(
        languageName: languageName,
        languageLocale: languageLocale,
      ),
    );
  }

  void getCurrentLanguage() {
    String? savedLanguageName =
        sharedPreferences.getString(AppVariableNames.currentLanguage);

    if (savedLanguageName != null) {
      final savedLanguageLocale =
          AppLists.languages[savedLanguageName] ?? const Locale('en', 'US');

      emit(
        state.copyWith(
          languageName: savedLanguageName,
          languageLocale: savedLanguageLocale,
        ),
      );
    }
  }
}

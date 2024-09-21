import 'dart:async';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/lists.dart';
import '../../../core/constants/variable_names.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences sharedPreferences;

  LanguageBloc(this.sharedPreferences) : super(const LanguageState()) {
    on<UpdateLanguage>(onUpdateLanguage);
    on<GetCurrentLanguage>(onGetCurrentLanguage);
  }

  FutureOr<void> onUpdateLanguage(
    UpdateLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    await sharedPreferences.setString(
      AppVariableNames.currentLanguage,
      event.languageName,
    );

    emit(
      state.copyWith(
        languageName: event.languageName,
        languageLocale: event.languageLocale,
      ),
    );
  }

  FutureOr<void> onGetCurrentLanguage(
    GetCurrentLanguage event,
    Emitter<LanguageState> emit,
  ) {
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

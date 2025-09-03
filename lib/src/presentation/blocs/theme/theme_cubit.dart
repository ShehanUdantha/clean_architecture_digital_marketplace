import '../../../core/constants/lists.dart';
import '../../../core/constants/variable_names.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeCubit(this.sharedPreferences) : super(const ThemeState());

  void init() {
    getCurrentThemeMode();
  }

  void updateThemeMode(String themeName, ThemeMode themeMode) async {
    await sharedPreferences.setString(
      AppVariableNames.currentTheme,
      themeName,
    );

    emit(
      state.copyWith(
        themeName: themeName,
        themeMode: themeMode,
      ),
    );
  }

  void getCurrentThemeMode() {
    String? savedThemeName =
        sharedPreferences.getString(AppVariableNames.currentTheme);

    if (savedThemeName != null) {
      final savedThemeMode =
          AppLists.themes[savedThemeName] ?? ThemeMode.system;

      emit(
        state.copyWith(
          themeName: savedThemeName,
          themeMode: savedThemeMode,
        ),
      );
    }
  }
}

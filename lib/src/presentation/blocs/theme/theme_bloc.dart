import 'dart:async';

import '../../../core/constants/variable_names.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/lists.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeBloc(this.sharedPreferences) : super(const ThemeState()) {
    on<UpdateThemeMode>(onUpdateThemeMode);
    on<GetCurrentThemeMode>(onGetCurrentThemeMode);
  }

  FutureOr<void> onUpdateThemeMode(
    UpdateThemeMode event,
    Emitter<ThemeState> emit,
  ) async {
    await sharedPreferences.setString(
      AppVariableNames.currentTheme,
      event.themeName,
    );

    emit(
      state.copyWith(
        themeName: event.themeName,
        themeMode: event.themeMode,
      ),
    );
  }

  FutureOr<void> onGetCurrentThemeMode(
    GetCurrentThemeMode event,
    Emitter<ThemeState> emit,
  ) {
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

  bool isDarkMode(BuildContext context) {
    if (state.themeMode == ThemeMode.system) {
      final brightness = MediaQuery.of(context).platformBrightness;
      return brightness == Brightness.dark;
    }
    return state.themeMode == ThemeMode.dark;
  }
}

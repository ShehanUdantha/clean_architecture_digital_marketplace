import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/theme_values.dart';
import 'theme_cubit_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
  });

  blocTest<ThemeCubit, ThemeState>(
    'emits no state when no theme is stored in SharedPreferences when init is called',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentTheme))
          .thenReturn(null);

      return ThemeCubit(mockSharedPreferences);
    },
    act: (cubit) => cubit.init(),
    expect: () => [],
  );

  blocTest<ThemeCubit, ThemeState>(
    'emits updated state with themeName, themeMode when UpdateThemeMode is called',
    build: () {
      when(mockSharedPreferences.setString(
        AppVariableNames.currentTheme,
        userSelectThemeKey,
      )).thenAnswer((_) async => true);

      return ThemeCubit(mockSharedPreferences);
    },
    act: (cubit) => cubit.updateThemeMode(
      userSelectThemeKey,
      userSelectThemeValue,
    ),
    expect: () => [
      const ThemeState().copyWith(
        themeName: userSelectThemeKey,
        themeMode: userSelectThemeValue,
      ),
    ],
  );

  blocTest<ThemeCubit, ThemeState>(
    'emits updated state with themeName, themeMode when GetCurrentThemeMode is called',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentTheme))
          .thenReturn(currentThemeKey);

      return ThemeCubit(mockSharedPreferences);
    },
    act: (cubit) => cubit.getCurrentThemeMode(),
    expect: () => [
      const ThemeState().copyWith(
        themeName: currentThemeKey,
        themeMode: currentThemeValue,
      ),
    ],
  );
}

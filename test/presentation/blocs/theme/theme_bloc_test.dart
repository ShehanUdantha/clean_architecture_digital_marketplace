import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/theme_values.dart';
import 'theme_bloc_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ThemeCubit themeCubit;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    themeCubit = ThemeCubit(mockSharedPreferences);
  });

  tearDown(() {
    themeCubit.close();
  });

  blocTest<ThemeCubit, ThemeState>(
    'emits updated state when UpdateThemeMode is added',
    build: () {
      when(mockSharedPreferences.setString(
        AppVariableNames.currentTheme,
        userSelectThemeKey,
      )).thenAnswer((_) async => true);

      return themeCubit;
    },
    act: (bloc) => bloc.updateThemeMode(
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
    'emits updated state with themeName, themeMode when GetCurrentThemeMode is added',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentTheme))
          .thenReturn(currentThemeKey);

      return themeCubit;
    },
    act: (bloc) => bloc.getCurrentThemeMode(),
    expect: () => [
      const ThemeState().copyWith(
        themeName: currentThemeKey,
        themeMode: currentThemeValue,
      ),
    ],
  );

  blocTest<ThemeCubit, ThemeState>(
    'emits no state when no theme is stored in SharedPreferences on GetCurrentThemeMode event',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentTheme))
          .thenReturn(null);

      return themeCubit;
    },
    act: (bloc) => bloc.getCurrentThemeMode(),
    expect: () => [],
  );
}

import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/theme_values.dart';
import 'theme_bloc_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ThemeBloc themeBloc;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    themeBloc = ThemeBloc(mockSharedPreferences);
  });

  tearDown(() {
    themeBloc.close();
  });

  blocTest<ThemeBloc, ThemeState>(
    'emits updated state when UpdateThemeMode is added',
    build: () {
      when(mockSharedPreferences.setString(
        AppVariableNames.currentTheme,
        userSelectThemeKey,
      )).thenAnswer((_) async => true);

      return themeBloc;
    },
    act: (bloc) => bloc.add(
      const UpdateThemeMode(
        themeName: userSelectThemeKey,
        themeMode: userSelectThemeValue,
      ),
    ),
    expect: () => [
      const ThemeState().copyWith(
        themeName: userSelectThemeKey,
        themeMode: userSelectThemeValue,
      ),
    ],
  );

  blocTest<ThemeBloc, ThemeState>(
    'emits updated state with themeName, themeMode when GetCurrentThemeMode is added',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentTheme))
          .thenReturn(currentThemeKey);

      return themeBloc;
    },
    act: (bloc) => bloc.add(GetCurrentThemeMode()),
    expect: () => [
      const ThemeState().copyWith(
        themeName: currentThemeKey,
        themeMode: currentThemeValue,
      ),
    ],
  );

  blocTest<ThemeBloc, ThemeState>(
    'emits no state when no theme is stored in SharedPreferences on GetCurrentThemeMode event',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentTheme))
          .thenReturn(null);

      return themeBloc;
    },
    act: (bloc) => bloc.add(GetCurrentThemeMode()),
    expect: () => [],
  );
}

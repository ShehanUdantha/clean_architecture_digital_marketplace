import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/constant_values.dart';
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
        fakeUserSelectThemeKey,
      )).thenAnswer((_) async => true);

      return themeBloc;
    },
    act: (bloc) => bloc.add(
      const UpdateThemeMode(
        themeName: fakeUserSelectThemeKey,
        themeMode: fakeUserSelectThemeValue,
      ),
    ),
    expect: () => [
      const ThemeState().copyWith(
        themeName: fakeUserSelectThemeKey,
        themeMode: fakeUserSelectThemeValue,
      ),
    ],
  );

  blocTest<ThemeBloc, ThemeState>(
    'emits updated state with themeName, themeMode when GetCurrentThemeMode is added',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentTheme))
          .thenReturn(fakeCurrentThemeKey);

      return themeBloc;
    },
    act: (bloc) => bloc.add(GetCurrentThemeMode()),
    expect: () => [
      const ThemeState().copyWith(
        themeName: fakeCurrentThemeKey,
        themeMode: fakeCurrentThemeValue,
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

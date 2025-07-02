import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/presentation/blocs/language/language_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/language_values.dart';
import 'language_bloc_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late LanguageCubit languageCubit;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    languageCubit = LanguageCubit(mockSharedPreferences);
  });

  tearDown(() {
    languageCubit.close();
  });

  blocTest<LanguageCubit, LanguageState>(
    'emits updated state with languageName, languageLocale when UpdateLanguage is added',
    build: () {
      when(mockSharedPreferences.setString(
        AppVariableNames.currentLanguage,
        userSelectLanguageName,
      )).thenAnswer((_) async => true);

      return languageCubit;
    },
    act: (bloc) => bloc.updateLanguage(
      userSelectLanguageName,
      userSelectLanguageLocale,
    ),
    expect: () => [
      const LanguageState().copyWith(
        languageName: userSelectLanguageName,
        languageLocale: userSelectLanguageLocale,
      ),
    ],
  );

  blocTest<LanguageCubit, LanguageState>(
    'emits updated state with languageName, languageLocale when GetCurrentLanguage is added',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentLanguage))
          .thenReturn(userSelectLanguageName);

      return languageCubit;
    },
    act: (bloc) => bloc.getCurrentLanguage(),
    expect: () => [
      const LanguageState().copyWith(
        languageName: userSelectLanguageName,
        languageLocale: userSelectLanguageLocale,
      ),
    ],
  );

  blocTest<LanguageCubit, LanguageState>(
    'emits no state when no languageName is stored in SharedPreferences on GetCurrentLanguage event',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentLanguage))
          .thenReturn(null);

      return languageCubit;
    },
    act: (bloc) => bloc.getCurrentLanguage(),
    expect: () => [],
  );
}

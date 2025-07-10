import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/presentation/blocs/language/language_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/language_values.dart';
import 'language_cubit_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    when(mockSharedPreferences.getString(AppVariableNames.currentLanguage))
        .thenReturn(null);
  });

  blocTest<LanguageCubit, LanguageState>(
    'emits updated state with languageName, languageLocale when UpdateLanguage is called',
    build: () {
      when(mockSharedPreferences.setString(
        AppVariableNames.currentLanguage,
        userSelectLanguageName,
      )).thenAnswer((_) async => true);

      return LanguageCubit(mockSharedPreferences);
    },
    act: (cubit) => cubit.updateLanguage(
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

  // TODO: need to implement
  // blocTest<LanguageCubit, LanguageState>(
  //   'emits updated state with languageName, languageLocale when GetCurrentLanguage is called',
  //   build: () {
  //     when(mockSharedPreferences.getString(AppVariableNames.currentLanguage))
  //         .thenReturn(userSelectLanguageName);

  //     return LanguageCubit(mockSharedPreferences);
  //   },
  //   act: (_) {},
  //   expect: () => [
  //     const LanguageState().copyWith(
  //       languageName: userSelectLanguageName,
  //       languageLocale: userSelectLanguageLocale,
  //     ),
  //   ],
  // );

  blocTest<LanguageCubit, LanguageState>(
    'emits no state when no languageName is stored in SharedPreferences on GetCurrentLanguage',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentLanguage))
          .thenReturn(null);

      return LanguageCubit(mockSharedPreferences);
    },
    act: (cubit) => cubit.getCurrentLanguage(),
    expect: () => [],
  );
}

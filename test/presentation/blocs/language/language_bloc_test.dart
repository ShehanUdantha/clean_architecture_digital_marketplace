import 'package:Pixelcart/src/core/constants/variable_names.dart';
import 'package:Pixelcart/src/presentation/blocs/language/language_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/constant_values.dart';
import 'language_bloc_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late LanguageBloc languageBloc;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    languageBloc = LanguageBloc(mockSharedPreferences);
  });

  tearDown(() {
    languageBloc.close();
  });

  blocTest<LanguageBloc, LanguageState>(
    'emits updated state with languageName, languageLocale when UpdateLanguage is added',
    build: () {
      when(mockSharedPreferences.setString(
        AppVariableNames.currentLanguage,
        fakeUserSelectLanguageName,
      )).thenAnswer((_) async => true);

      return languageBloc;
    },
    act: (bloc) => bloc.add(
      UpdateLanguage(
        languageName: fakeUserSelectLanguageName,
        languageLocale: fakeUserSelectLanguageLocale,
      ),
    ),
    expect: () => [
      const LanguageState().copyWith(
        languageName: fakeUserSelectLanguageName,
        languageLocale: fakeUserSelectLanguageLocale,
      ),
    ],
  );

  blocTest<LanguageBloc, LanguageState>(
    'emits updated state with languageName, languageLocale when GetCurrentLanguage is added',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentLanguage))
          .thenReturn(fakeUserSelectLanguageName);

      return languageBloc;
    },
    act: (bloc) => bloc.add(GetCurrentLanguage()),
    expect: () => [
      const LanguageState().copyWith(
        languageName: fakeUserSelectLanguageName,
        languageLocale: fakeUserSelectLanguageLocale,
      ),
    ],
  );

  blocTest<LanguageBloc, LanguageState>(
    'emits no state when no languageName is stored in SharedPreferences on GetCurrentLanguage event',
    build: () {
      when(mockSharedPreferences.getString(AppVariableNames.currentLanguage))
          .thenReturn(null);

      return languageBloc;
    },
    act: (bloc) => bloc.add(GetCurrentLanguage()),
    expect: () => [],
  );
}

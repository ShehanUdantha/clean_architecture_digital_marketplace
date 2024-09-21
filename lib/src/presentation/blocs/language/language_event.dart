part of 'language_bloc.dart';

sealed class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class UpdateLanguage extends LanguageEvent {
  final String languageName;
  final Locale languageLocale;

  const UpdateLanguage({
    required this.languageName,
    required this.languageLocale,
  });
}

class GetCurrentLanguage extends LanguageEvent {}

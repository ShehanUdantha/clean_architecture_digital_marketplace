// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class UpdateThemeMode extends ThemeEvent {
  final String themeName;
  final ThemeMode themeMode;

  const UpdateThemeMode({
    required this.themeName,
    required this.themeMode,
  });
}

class GetCurrentThemeMode extends ThemeEvent {}

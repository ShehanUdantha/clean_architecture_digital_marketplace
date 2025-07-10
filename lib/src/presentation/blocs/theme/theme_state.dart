part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final String themeName;
  final ThemeMode themeMode;

  const ThemeState({
    this.themeName = 'System',
    this.themeMode = ThemeMode.system,
  });

  ThemeState copyWith({
    String? themeName,
    ThemeMode? themeMode,
  }) =>
      ThemeState(
        themeName: themeName ?? this.themeName,
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  List<Object> get props => [
        themeName,
        themeMode,
      ];
}

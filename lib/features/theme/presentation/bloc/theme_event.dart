part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;
  ChangeThemeEvent(this.themeMode);
}

class LoadThemeEvent extends ThemeEvent {}
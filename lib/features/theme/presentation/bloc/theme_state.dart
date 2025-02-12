part of 'theme_bloc.dart';

abstract class ThemeState {
  final ThemeMode themeMode;
  ThemeState(this.themeMode);
}

class ThemeInitial extends ThemeState {
  ThemeInitial() : super(ThemeMode.light);
}

class ThemeLoaded extends ThemeState {
  ThemeLoaded(ThemeMode themeMode) : super(themeMode);
}
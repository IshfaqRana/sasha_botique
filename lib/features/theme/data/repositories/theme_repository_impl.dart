import 'package:flutter/material.dart';
import 'package:sasha_botique/features/theme/domain/repositories/theme_repository.dart';

import '../source/theme_data_source.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl(this.localDataSource);

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeString = await localDataSource.getThemeMode();
    return _parseThemeMode(themeString);
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await localDataSource.setThemeMode(themeMode.toString());
  }

  ThemeMode _parseThemeMode(String themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

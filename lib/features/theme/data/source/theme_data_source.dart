import '../../../../core/helper/shared_preferences_service.dart';

abstract class ThemeLocalDataSource {
  Future<String> getThemeMode();
  Future<void> setThemeMode(String themeMode);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferencesService preferencesService;

  ThemeLocalDataSourceImpl(this.preferencesService);

  @override
  Future<String> getThemeMode() async {
    return preferencesService.getThemeMode();
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    await preferencesService.setThemeMode(themeMode);
  }
}
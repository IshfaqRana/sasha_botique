import 'package:flutter/material.dart';


extension CustomColorScheme on ColorScheme {
  // Dynamic colors that change based on theme
  Color get lightGrey => brightness == Brightness.light
      ? const Color.fromARGB(255, 92, 91, 91)
      : const Color(0xFF636363);

  Color get themeColor => brightness == Brightness.light
      ? Colors.white
      : const Color.fromARGB(255, 59, 59, 59);

  Color get lightDarkGrey => brightness!= Brightness.light
      ? const Color.fromARGB(255, 102, 100, 100)
      : Colors.white70;

  Color get secondaryThemeColor => brightness == Brightness.light
      ? secondary
      : const Color(0xFF4DD0E1);

  Color get blackWhite => brightness == Brightness.light
      ? Colors.black
      : Colors.white;

  Color get blackGrey => brightness == Brightness.light
      ? Colors.black
      : Colors.white70;

  Color get textColor => brightness != Brightness.light
      ? Colors.black
      : Colors.white;

  // Static colors that don't change with theme
  Color get errorRed => Colors.red;
  Color get successGreen => const Color(0xFF00E676);
  Color get infoBlue => const Color(0xFF2196F3);
  Color get warningOrange => const Color(0xFFFF9800);
  Color get customPurple => const Color(0xFFBB86FC);
  Color get primaryColor => const Color(0xFF6B4EFF);
  Color get whiteColor => Colors.white;
  Color get lightWhiteColor => Colors.white70;
  Color get cartTileColor => Color(0xFFF1F4FB);

  Color get grey => const Color(0xFFA1A1A1);
}

extension ThemeHelper on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}

Color lightWhiteColor = Color(0xFF979797);
Color gradientColor = Color(0xFF212121);
LinearGradient appGradientColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
  Colors.black,
      gradientColor,
]);
LinearGradient appGradientColor2 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
  Colors.black,
  lightWhiteColor,
]);
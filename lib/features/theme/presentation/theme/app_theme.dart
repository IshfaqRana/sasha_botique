import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = const Color(0xFF000000);

  static Color darkThemeGreyColor = const Color.fromARGB(255, 59, 59, 59);
  static ThemeData lightTheme = ThemeData(

    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    fontFamily: 'Lato',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      // labelStyle: TextStyle(color: Colors.red),
      // hintStyle: TextStyle(color: Colors.red),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    ),
    textTheme: TextTheme(
      bodySmall: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w400, color: const Color.fromARGB(255, 92, 91, 91), fontSize: 15),
      bodyMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 14,
        color: Colors.black54,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        color: Colors.black87,
      ), //  headlineSmall: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 92, 91, 91), fontSize: 15),
      headlineSmall: TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),headlineMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleSmall: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, color:  Colors.black, fontSize: 15),
      titleMedium: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, color: Colors.black, fontSize: 18),
      titleLarge: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, color: Colors.black, fontSize: 30),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStateProperty.all(Colors.black))
    ),
    iconTheme: IconThemeData(color: Colors.black),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          iconColor: WidgetStateProperty.all(Colors.black)

      ),
    ),

  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
    ),

    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: const Color(0xFF4DD0E1),
      surface: darkThemeGreyColor, // const Color(0xFF1E1E1E),
      // Darker grey for surface
      // background: darkThemeGreyColor,
      // Background
      error: Colors.red, // Red
    ),
    expansionTileTheme:
        ExpansionTileThemeData(collapsedBackgroundColor: darkThemeGreyColor, collapsedIconColor: Colors.white, backgroundColor: darkThemeGreyColor, iconColor: Colors.white),
    fontFamily: 'Lato',
    textTheme: TextTheme(
      bodySmall: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w400, color: Colors.white70, fontSize: 15),
      bodyMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 14,
        color: Colors.white54,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        color: Colors.white70,
      ), //  headlineSmall: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w500, color: Colors.white70, fontSize: 15),
      headlineMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleSmall: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w500, color: Colors.white70, fontSize: 15),
      titleMedium: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),
      titleLarge: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
    ),
  );
}

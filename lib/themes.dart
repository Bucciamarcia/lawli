import "package:flutter/material.dart";

class LightTheme {
  ThemeData get themeData {
    return ThemeData(
      colorSchemeSeed: Colors.lightBlue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.lightBlue,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.black,
          fontSize: 40,
        ),
        displayMedium: TextStyle(
          color: Colors.black,
          fontSize: 30,
        ),
        labelSmall: TextStyle(
          color: Color.fromARGB(255, 75, 75, 75),
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.lightBlue[700]),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color.fromRGBO(117, 146, 175, 100),
        indent: 10,
        endIndent: 10,
      ),
    );
  }
}

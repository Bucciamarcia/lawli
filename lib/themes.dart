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
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.lightBlue[700]),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  } 
}
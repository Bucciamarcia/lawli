import "package:flutter/material.dart";

class LightTheme {
  ThemeData get themeData {
    return ThemeData(
      primarySwatch: Colors.lightBlue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.lightBlue,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),

    );
  } 
}
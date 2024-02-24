import 'package:flutter/material.dart';

class ResponsiveLayout {
  static const double desktopBreakpoint = 600;

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isDesktop(BuildContext context) {
    double width = screenWidth(context);
    return width > desktopBreakpoint;
  }
}
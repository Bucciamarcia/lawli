import 'package:flutter/material.dart';

/// A class that provides utility methods for handling responsive layouts.
class ResponsiveLayout {
  
  static const double desktopBreakpoint = 600;

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isDesktop(BuildContext context) {
    double width = screenWidth(context);
    return width > desktopBreakpoint;
  }

  static EdgeInsets mainWindowPadding(BuildContext context) {
    bool desktop = isDesktop(context);
    return EdgeInsets.all(desktop ? 0 : 10);
  }
}
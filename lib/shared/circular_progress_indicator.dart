import 'package:flutter/material.dart';

/// A class to show a circular progress indicator
class CircularProgress {
  /// Show a circular progress indicator
  static Future<dynamic> show(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  /// Simply pop the current screen
  static void pop(BuildContext context) {
    return Navigator.of(context).pop();
  }
}

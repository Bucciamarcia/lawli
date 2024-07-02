import "package:flutter/material.dart";

/// A class to show a confirmation dialog
class ConfirmationMessage {
  /// Show a confirmation dialog
  static Future<dynamic> show(
      BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

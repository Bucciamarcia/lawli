import 'package:flutter/material.dart';

/// A class to show a circular progress indicator
///
/// Show with: `OverlayEntry? overlay = CircularProgress.show(context);`
///
/// Remove with:
///
/// ```dart
/// overlay?.remove();
/// overlay = null;
/// ```
class CircularProgress {
  /// Show a circular progress indicator
  static OverlayEntry? show(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Stack(
        children: [
          // Add a transparent container to fade the whole screen
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    });
    Overlay.of(context).insert(overlayEntry);
    return overlayEntry;
  }

  /// Simply pop the current screen
  static void pop(BuildContext context) {
    return Navigator.of(context).pop();
  }
}

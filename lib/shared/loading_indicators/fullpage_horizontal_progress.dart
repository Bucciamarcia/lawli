import 'package:flutter/material.dart';
import 'package:lawli/shared/loading_indicators/horizontal_widget.dart';

/// Shows a full page horizontal progress indicator with screen dimming.
class FullpageHorizontalProgress {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) {
      debugPrint("Value already set");
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            const Center(
              child: HorizontalWidget(),
            )
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

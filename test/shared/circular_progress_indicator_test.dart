import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawli/shared/circular_progress_indicator.dart';

void main() {
  testWidgets(
    "CircularProgressIndicator create and pop.",
    (tester) async {
      OverlayEntry? overlay;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    overlay = CircularProgress.show(context);
                  },
                  child: const Text("Show Dialog"),
                ),
              );
            },
          ),
        ),
      );

      // Find the button
      var button = find.text("Show Dialog");
      expect(button, findsOneWidget);

      // Tap the button and show the overlay
      await tester.tap(button);
      await tester.pump(); // Let the button press be processed
      await tester.pump(); // Pump again for the overlay to be displayed

      // Check if the CircularProgressIndicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Remove the overlay
      overlay?.remove();
      overlay = null;

      // Pump frames manually to let the UI settle
      await tester.pump(); // Initial frame

      // Ensure the CircularProgressIndicator is no longer visible
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
}

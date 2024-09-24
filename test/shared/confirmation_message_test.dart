import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawli/shared/confirmation_message.dart';

void main() {
  testWidgets('ConfirmationMessage shows the correct dialog',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    ConfirmationMessage.show(
                        context, 'Confirm', 'Are you sure?');
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            );
          },
        ),
      ),
    );

    // Verify the button is displayed
    expect(find.text('Show Dialog'), findsOneWidget);

    // Tap the button to show the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle(); // Wait for the dialog to open

    // Verify the title and content of the dialog
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('Are you sure?'), findsOneWidget);

    // Verify the OK button is present
    expect(find.text('OK'), findsOneWidget);

    // Tap the OK button and close the dialog
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle(); // Wait for the dialog to close

    // Verify the dialog is closed
    expect(find.byType(AlertDialog), findsNothing);
  });
}

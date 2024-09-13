import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawli/services/services.dart';
import 'package:lawli/shared/drawer.dart';
import 'package:mockito/annotations.dart';
import "../firebase_mock.dart";

@GenerateMocks([AuthService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(
    () async {
      await Firebase.initializeApp();
    },
  );
  testWidgets(
    "Test logged out drawer",
    (tester) async {
      // Build the widget.
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return const Scaffold(drawer: ResponsiveDrawer());
            },
          ),
        ),
      );

      // Wait for asynchronous operations.
      await tester.pumpAndSettle();

      ScaffoldState scaffold = tester.firstState(find.byType(Scaffold));
      scaffold.openDrawer();
      await tester.pumpAndSettle();

      // Find the drawer widget.
      final drawerFinder = find.byType(Drawer);

      expect(drawerFinder, findsOneWidget);
      expect(find.text("Log in"), findsOneWidget);
      expect(find.text("Assistiti"), findsNothing);
      expect(find.text("Pratiche"), findsNothing);
    },
  );
}

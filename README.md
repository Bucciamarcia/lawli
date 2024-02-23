# lawli

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Layout builder

Code for each new page:

```dart
import 'package:flutter/material.dart';
import "../../shared/shared.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const Widget appBarText = Text("Benvenuto in Lawli!");

  Scaffold body(BuildContext context) {
    const String headerText = "Benvenuto in Lawli!";
    return const Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LogoImage(),
              SizedBox(height: 20),
              TextHeader(headerText: headerText),
              SizedBox(height: 20),
              LoginBlock(),
              FooterWidget(),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: appBarText,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return DesktopVersion(body: body(context), appBar: appBar(context));
        } else {
          return MobileVersion(body: body(context), appBar: appBar(context));
        }
      },
    );
  }
}
```

The reason for this code is that there is a different menu on desktop.
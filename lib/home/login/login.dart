import 'package:flutter/material.dart';
import "../../shared/shared.dart";
import 'loginblock.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
        title: const Text("Benvenuto in Lawli!"),
      );
  }

  @override
  Widget build(BuildContext context) {
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

class DesktopVersion extends StatelessWidget {
  final Scaffold body;
  final AppBar appBar;
  const DesktopVersion({super.key, required this.body, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          Container(
            width: 300,
            child: ResponsiveDrawer(),
          ),
          Expanded(
            child: Center(
              child: body,
            ),
          ),
        ],
      )
    );
  }
}

class MobileVersion extends StatelessWidget {
  final Scaffold body;
  final AppBar appBar;
  const MobileVersion({super.key, required this.body, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const ResponsiveDrawer(),
      body: body
    );
  }
}




















class LogoImage extends StatelessWidget {
  final double width;

  const LogoImage({super.key, this.width = 250});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      logoPath,
      width: MediaQuery.of(context).size.width >= 600
          ? width
          : MediaQuery.of(context).size.width * 0.6,
    );
  }
}

class TextHeader extends StatelessWidget {
  final String headerText;

  const TextHeader({super.key, required this.headerText});

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

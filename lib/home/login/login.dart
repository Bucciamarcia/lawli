import 'package:flutter/material.dart';
import "../../shared/shared.dart";
import 'loginblock.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Variables
    const String headerText = "Benvenuto in Lawli!";
    const String appbarText = "Login";
    // End variables

    return Scaffold(
      appBar: AppBar(
        title: const Text(appbarText),
      ),
      body: const Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            LogoImage(),
            SizedBox(height: 20),
            TextHeader(headerText: headerText),
            SizedBox(height: 20),
            LoginBlock(),
            FooterWidget(),
          ]),),
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

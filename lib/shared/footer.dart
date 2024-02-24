import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200], // Adjust styling as needed
        padding: const EdgeInsets.all(16.0),
        child: const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "© Stefano Mini Consulting SLU",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12.0),
            )));
  }
}

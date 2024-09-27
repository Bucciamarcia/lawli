import 'package:flutter/material.dart';

class HorizontalWidget extends StatefulWidget {
  const HorizontalWidget({super.key});

  @override
  State<HorizontalWidget> createState() => _HorizontalWidgetState();
}

class _HorizontalWidgetState extends State<HorizontalWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Placeholder(),
    );
  }
}

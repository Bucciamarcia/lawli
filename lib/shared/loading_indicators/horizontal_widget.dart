import 'dart:async';

import 'package:flutter/material.dart';

class LinearProgressIndicatorCustom extends StatefulWidget {
  final double initalValue;
  const LinearProgressIndicatorCustom({super.key, required this.initalValue});

  @override
  State<LinearProgressIndicatorCustom> createState() =>
      LinearProgressIndicatorCustomState();
}

class LinearProgressIndicatorCustomState
    extends State<LinearProgressIndicatorCustom> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    controller.value = 0.3;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (controller.value < 1.0) {
          controller.value += 0.005;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void changeTimer(double newValue) {
    controller.value = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        height: 15,
        child: LinearProgressIndicator(value: controller.value));
  }
}

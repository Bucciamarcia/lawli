import 'package:flutter/material.dart';
import 'package:lawli/shared/shared.dart';

class MobileVersion extends StatelessWidget {
  final Scaffold body;
  final AppBar appBar;
  const MobileVersion({super.key, required this.body, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar, drawer: const ResponsiveDrawer(), body: body);
  }
}

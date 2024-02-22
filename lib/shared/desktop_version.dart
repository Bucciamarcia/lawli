import 'package:flutter/material.dart';
import 'package:lawli/shared/shared.dart';

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
        ));
  }
}

import 'package:flutter/material.dart';
import "../../shared/shared.dart";

class AssistitiScreen extends StatelessWidget {
  const AssistitiScreen({super.key});

  Scaffold body(BuildContext context) {
    return const Scaffold(
      
      // PAGE BODY HERE

    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        
        centerTitle: true,
        // APPBAR HERE

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
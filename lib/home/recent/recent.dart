import 'package:flutter/material.dart';
import "../../shared/shared.dart";

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  Scaffold body(BuildContext context) {
    return const Scaffold(
      
      body: Center(
        child: Text(
          '''
          In questa schermata verranno presentate le pratiche recenti dell'utente.
          Naviga le tue pratiche con il menù a sinistra.
          ''',
          style: TextStyle(fontSize: 20),
        )
      )

    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar(BuildContext context) {
      return AppBar(
        
        centerTitle: true,
        title: const Text('Pratiche recenti'),
        
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

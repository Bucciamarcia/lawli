import 'package:flutter/material.dart';
import "../services/auth.dart";

class ResponsiveDrawer extends StatelessWidget {
  const ResponsiveDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    if (AuthService().isSignedIn()) {
      return Drawer(
        backgroundColor:
            MediaQuery.of(context).size.width > 600 ? Colors.grey[300] : null,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          children: MenuElements().listElements,
        ),
      );
    } else {
      return Drawer(
        child: ListView(
          children: const [
            ListTile(title: Text('Log in')),
          ],
        ),
      );
    }
  }
}

class MenuElements {
  List<Widget> listElements = [
    const SizedBox(
        height: 100, child: DrawerHeader(child: Text('Drawer Header'))),
    const ListTile(title: Text('Item 1')),
    const ListTile(title: Text('Item 2')),
  ];
}

class DrawerStyle {
  
}

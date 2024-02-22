import 'package:flutter/material.dart';
import "../services/auth.dart";

class ResponsiveDrawer extends StatelessWidget {
  const ResponsiveDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    if (AuthService().isSignedIn()) {
    return Drawer(
      child: ListView(
        children: const [
          // Always show the header
          DrawerHeader(child: Text('Drawer Header')),
          ListTile(title: Text('Item 1')),
          ListTile(title: Text('Item 2')),
        ],
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

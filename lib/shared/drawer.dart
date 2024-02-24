import 'package:flutter/material.dart';
import "../services/services.dart";

class ResponsiveDrawer extends StatelessWidget {
  const ResponsiveDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:
          ResponsiveLayout.isDesktop(context) ? Colors.grey[300] : null,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        children:
            AuthService().isSignedIn() ? MenuElements(context: context).loggedInElements() : MenuElements(context: context).loggedOutElements(),
      ),
    );
  }
}

class MenuElements {
  final BuildContext context;
  List<Widget> listElements = [];

  MenuElements({required this.context});

  loggedInElements() {
    listElements = [
      SizedBox(
          height: ResponsiveLayout.isDesktop(context) ? 100 : null,
          child: const DrawerHeader(child: Text('Menù principale'))),
      const ListTile(title: Text('Item 1')),
      const ListTile(title: Text('Item 2')),
    ];
    return listElements;
  }

  loggedOutElements() {
    listElements = [
      const ListTile(title: Text('Log in')),
    ];
    return listElements;
  }
}

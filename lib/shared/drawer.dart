import 'package:flutter/material.dart';

class ResponsiveDrawer extends StatelessWidget {
  const ResponsiveDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Always show the header
          const DrawerHeader(child: Text('Drawer Header')),
          // Show list items based on screen size
            const ListTile(title: Text('Item 1')),
            const ListTile(title: Text('Item 2')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ResponsiveDrawer extends StatelessWidget {
  const ResponsiveDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Drawer(
          child: ListView(
            children: [
              // Always show the header
              const DrawerHeader(child: Text('Drawer Header')),
              // Show list items based on screen size
              if (constraints.maxWidth > 800) ...[
                const ListTile(title: Text('Item 1')),
                const ListTile(title: Text('Item 2')),
              ] else ...[
                const ListTile(title: Text('Item 1')),
                const ListTile(title: Text('Item 2')),
                const ListTile(title: Text('Item 3')),
              ],
            ],
          ),
        );
      },
    );
  }
}

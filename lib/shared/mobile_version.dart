import 'package:flutter/material.dart';
import 'package:lawli/shared/shared.dart';
import 'package:provider/provider.dart';
import '../services/firestore.dart';
import '../services/provider.dart';

class MobileVersion extends StatelessWidget {
  final Widget body;
  final AppBar appBar;
  const MobileVersion({super.key, required this.body, required this.appBar});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setAccountId(context));
    return Scaffold(
        appBar: appBar, drawer: const ResponsiveDrawer(), body: body);
  }
  void setAccountId(context) async {
    if (Provider.of<DashboardProvider>(context, listen: false).accountName ==
        "") {
      Provider.of<DashboardProvider>(context, listen: false)
          .setAccountName(await AccountDb().getAccountName());
    }
  }
}

import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';
import 'package:lawli/shared/circular_progress_indicator.dart';

import 'models.dart';

class AccountMainView extends StatelessWidget {
  final AccountInfo account;
  const AccountMainView({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
  return Text("Account: ${account.id}");
  }
}

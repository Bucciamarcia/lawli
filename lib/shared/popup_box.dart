import 'package:flutter/material.dart';

void displayAlertPopup(
  BuildContext context, String title, String message, String buttonText) {
  showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
    title: Text(title),
    content: SizedBox(
      width: 500,
      child: Text(message),
    ),
    actions: <Widget>[
      TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(buttonText),
      ),
    ],
    );
  },
  );
}

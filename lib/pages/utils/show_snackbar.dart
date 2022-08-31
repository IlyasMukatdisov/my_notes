import 'dart:developer' as dev_tools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showSnackBar(String message, BuildContext context) {
  SnackBar snackBar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.justify,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> showErrorDialog(BuildContext context, String message) {
  dev_tools.log(message);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('An error occured'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'))
        ],
      );
    },
  );
}

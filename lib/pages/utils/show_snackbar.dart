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

void showErrorSnackBar(FirebaseAuthException e, BuildContext context) {
  debugPrint(e.code);
  String errorMessage = e.message ?? 'Unknown Error. Please try again later';
  showSnackBar(errorMessage, context);
}

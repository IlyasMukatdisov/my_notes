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
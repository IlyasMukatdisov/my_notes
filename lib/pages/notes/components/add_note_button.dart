import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';

Widget addNoteButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, Routes.createUpdateNotePageRoute);
      },
      icon: const Icon(Icons.note_add));
}

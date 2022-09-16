import 'package:flutter/material.dart';
import 'package:my_notes/utils/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog({required BuildContext context}) {
  return showGenericDialog(
      context: context,
      title: 'Sharing',
      content: "You can't share empty note",
      optionBuilder: () => {
            'OK': null,
          });
}

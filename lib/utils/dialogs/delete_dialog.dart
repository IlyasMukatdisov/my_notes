import 'package:flutter/cupertino.dart';
import 'package:my_notes/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog({
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Note',
    content: 'Are you sure want to delete the note?',
    optionBuilder: () => {
      'Delete': true,
      'Cancel':false
    },
  ).then((value) => value ?? false);
}

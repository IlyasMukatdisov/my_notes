import 'package:flutter/cupertino.dart';
import 'package:my_notes/pages/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String text,
}) {
  return showGenericDialog<void>(
    context: context,
    title: 'An error occurred',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}

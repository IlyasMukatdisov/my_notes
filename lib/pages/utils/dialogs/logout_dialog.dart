import 'package:flutter/cupertino.dart';
import 'package:my_notes/pages/utils/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog({
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure want to log out?',
    optionBuilder: () => {
      'Log Out': true,
      'Cancel': false,
    },
  ).then(
    (value) => value ?? false,
  );
}

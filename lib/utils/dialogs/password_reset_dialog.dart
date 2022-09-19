import 'package:flutter/cupertino.dart';
import 'package:my_notes/utils/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content:
        "We've sent you and password reset email. Please check your email for more information",
    optionBuilder: () => {
      'OK': null,
    },
  );
}

import 'package:flutter/material.dart';

class Utilities {
  Utilities._();

  static bool isKeyboardShowing(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static closeKeyboard(BuildContext context) {
    if (!isKeyboardShowing(context)) return false;
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

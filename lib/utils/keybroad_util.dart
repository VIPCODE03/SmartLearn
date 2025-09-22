import 'package:flutter/cupertino.dart';

//---   Ẩn bàn phím   --------------------------------------------------
void hideKeyboardAndRemoveFocus(BuildContext context) {
  FocusManager.instance.primaryFocus?.unfocus();
  FocusScope.of(context).unfocus();
}
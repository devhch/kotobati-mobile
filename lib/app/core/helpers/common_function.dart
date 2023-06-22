/*
* Created By Mirai Devs.
* On 06/22/2023.
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void miraiPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
  FocusScope.of(context).requestFocus(FocusNode());
}

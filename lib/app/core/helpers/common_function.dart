/*
* Created By Mirai Devs.
* On 06/22/2023.
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

void miraiPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
  FocusScope.of(context).requestFocus(FocusNode());
}

Future<void> requestPermission() async {
  final PermissionStatus status = await Permission.storage.request();
  miraiPrint("PermissionStatus $status");
  if (status == PermissionStatus.permanentlyDenied) {
    AppMiraiDialog.snackBar(
      title: 'Storage Permission Denied!',
      message:
      'Please allow storage permission to save the book that you are going to download...',
    );
    openAppSettings();
  }
}
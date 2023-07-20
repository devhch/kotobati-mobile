/*
* Created By Mirai Devs.
* On 06/22/2023.
*/


import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

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

  miraiPrint("isGranted: ${status.isGranted}");
  miraiPrint("PermissionStatus $status");
  if (status == PermissionStatus.permanentlyDenied) {
    AppMiraiDialog.snackBar(
      title: 'Storage Permission Denied!',
      message:
          'Please allow storage permission to save the book that you are going to download...',
      duration: 4,
    );
    openAppSettings();
  }
}

Future<void> shareFile(String filePath, String subject) async {
  try {
    await Share.shareXFiles(<XFile>[XFile(filePath)], subject: subject);
  } catch (e) {
    // Handle sharing error
    miraiPrint('Error sharing file: $e');
  }
}

bool deleteFile(String filePath) {
  File file = File(filePath);
  if (file.existsSync()) {
    file.deleteSync();
    miraiPrint('<========================>');
    miraiPrint('File deleted successfully.');
    miraiPrint('<========================>');
    return true;
  } else {
    miraiPrint('<==================>');
    miraiPrint('File does not exist.');
    miraiPrint('<==================>');
    return false;
  }
}

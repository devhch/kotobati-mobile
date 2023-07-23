/*
* Created By Mirai Devs.
* On 06/22/2023.
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:path_provider/path_provider.dart';
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
      message: 'Please allow storage permission to save the book that you are going to download...',
      duration: 4,
    );
    openAppSettings();
  }
}

Future<void> shareFile(String filePath, {String? subject, String? text}) async {
  try {
    await Share.shareXFiles(<XFile>[XFile(filePath)], subject: subject, text: text);
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

Future<CroppedFile?> cropSquareImage(String path) async => await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          /*
          toolbarTitle: 'Cropper',
          toolbarColor: AppTheme.keyAppColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
         */
          toolbarTitle: 'Cropper',
          toolbarColor: AppTheme.keyAppColor,
          toolbarWidgetColor: Colors.white,
          cropFrameColor: AppTheme.keyAppColor,
          activeControlsWidgetColor: AppTheme.keyAppColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          backgroundColor: AppTheme.keyAppColor,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

Future<String> getFileSize(String filepath, int decimals) async {
  File file = File(filepath);
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const List<String> suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  int i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

Future<Size> calculateImageDimension(File fileImage) {
  Completer<Size> completer = Completer<Size>();
  Image image = Image.file(fileImage);
  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        ui.Image myImage = image.image;
        Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
        completer.complete(size);
      },
    ),
  );
  return completer.future;
}

Future<File> uint8ListToFile(Uint8List data, String fileName, {String? tempDir}) async {
  // Get the temporary directory (app cache) or provide a custom temporary directory
  final tempDirectory = tempDir != null ? Directory(tempDir) : await getTemporaryDirectory();

  // Create the temporary file
  final file = File('${tempDirectory.path}/$fileName');

  // Write the Uint8List data to the temporary file
  await file.writeAsBytes(data);

  return file;
}

Future<Image> convertFileToImage(File picture) async {
  List<int> imageBase64 = picture.readAsBytesSync();
  String imageAsString = base64Encode(imageBase64);
  Uint8List uint8list = base64.decode(imageAsString);
  Image image = Image.memory(uint8list);
  return image;
}

void precacheImages(List<String> imagePaths, BuildContext context) async {
  for (String path in imagePaths) {
    // The `precacheImage` function loads the image into the cache
    await precacheImage(Image.asset(path).image, context);
  }
}

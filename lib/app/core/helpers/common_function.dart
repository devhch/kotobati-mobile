/*
* Created By Mirai Devs.
* On 06/22/2023.
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  //final PermissionStatus manageExternalStorage = await Permission.manageExternalStorage.request();

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

Future<void> shareBook(
  String originalFilePath,
  String title, {
  required BuildContext context,
}) async {
  File file = File(originalFilePath);

  // Create a temporary copy of the file with a ".pdf" extension.
  final String tempCopyPath = '$originalFilePath.pdf';

  //if (!await File(tempCopyPath).exists()) {
  File newFile = await file.copy(tempCopyPath);

  /// Share File
  await shareFile(XFile(file.path), subject: title, context: context);
}

Future<void> shareFile(XFile file,
    {String? subject, String? text, required BuildContext context}) async {
  final box = context.findRenderObject() as RenderBox?;
  try {
    await Share.shareXFiles(
      <XFile>[file],
      subject: subject,
      text: text,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  } catch (e) {
    // Handle sharing error
    miraiPrint('Error sharing file: $e');
  }
}

// Function to convert a File to XFile
XFile? convertFileToXFile(File file) {
  try {
    // Read the contents of the File as bytes
    final Uint8List bytes = file.readAsBytesSync();

    // Create an XFile with a unique name and the file's bytes
    final XFile xFile = XFile.fromData(bytes);
    miraiPrint('Converting File to XFile: Done');
    return xFile;
  } catch (e) {
    miraiPrint('Error converting File to XFile: $e');
    return null;
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

// Future<CroppedFile?> cropSquareImage(String path) async => await ImageCropper().cropImage(
//       sourcePath: path,
//       aspectRatioPresets: <CropAspectRatioPreset>[
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9
//       ],
//       uiSettings: <PlatformUiSettings>[
//         AndroidUiSettings(
//           /*
//           toolbarTitle: 'Cropper',
//           toolbarColor: AppTheme.keyAppColor,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//          */
//           toolbarTitle: 'Cropper',
//           toolbarColor: AppTheme.keyAppColor,
//           toolbarWidgetColor: Colors.white,
//           cropFrameColor: AppTheme.keyAppColor,
//           activeControlsWidgetColor: AppTheme.keyAppColor,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//           backgroundColor: AppTheme.keyAppColor,
//         ),
//         IOSUiSettings(title: 'Cropper'),
//       ],
//     );

Future<String> getFileSize(String filepath, int decimals) async {
  File file = File(filepath);
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const List<String> suffixes = <String>["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
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
  final Directory tempDirectory =
      tempDir != null ? Directory(tempDir) : await getTemporaryDirectory();

  // Create the temporary file
  final File file = await File('${tempDirectory.path}/$fileName').create();

  final Uint8List bytes = data.buffer.asUint8List();

  // Write the Uint8List data to the temporary file
  await file.writeAsBytes(bytes);

  return file;
}

Future<Image> convertFileToImage(File picture) async {
  List<int> imageBase64 = picture.readAsBytesSync();
  String imageAsString = base64Encode(imageBase64);
  Uint8List uint8list = base64.decode(imageAsString);
  Image image = Image.memory(uint8list);
  return image;
}

Future<Uint8List> convertFileToUint8List(File picture) async {
  List<int> imageBase64 = picture.readAsBytesSync();
  String imageAsString = base64Encode(imageBase64);
  Uint8List uint8list = base64.decode(imageAsString);
  return uint8list;
}

void precacheImages(List<String> imagePaths, BuildContext context) async {
  for (String path in imagePaths) {
    // The `precacheImage` function loads the image into the cache
    await precacheImage(Image.asset(path).image, context);
  }
}

/// If you name your createFolder(".folder") that folder will be hidden.
/// If you create a .nomedia file in your folder, other apps won't be able to scan your folder.
Future<String> createFolder() async {
  await requestPermission();

  // The app name is:
  const String appName = 'Kotobati';

  /// getExternalStorageDirectory For Android, and getApplicationSupportDirectory For iOS...
  final Directory dir = Directory(
    '${(Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationSupportDirectory())!.path}/$appName',
  );

  /// Let's Check permission...
  PermissionStatus status = await Permission.storage.status;
  if (!status.isGranted) {
    await requestPermission();
  }

  /// Let's check if the directory is exists...
  if ((await dir.exists())) {
    return dir.path;
  } else {
    dir.create();
    return dir.path;
  }
}

String extractFilename(String value) {
  RegExp filenameRegex = RegExp(r'filename[^;=\n]*=["\"]?([^;"\"]*)');
  Match? match = filenameRegex.firstMatch(value);

  if (match != null) {
    String filename = match.group(1) ?? '';
    return Uri.decodeComponent(filename);
  }

  return '';
}

bool isArabic(String text) {
  for (int codeUnit in text.runes) {
    if ((codeUnit >= 0x0600 && codeUnit <= 0x06FF) || // Arabic
        (codeUnit >= 0x0750 && codeUnit <= 0x077F) || // Arabic Supplement
        (codeUnit >= 0x08A0 && codeUnit <= 0x08FF) || // Arabic Extended-A
        (codeUnit >= 0xFB50 && codeUnit <= 0xFDFF) || // Arabic Presentation Forms-A
        (codeUnit >= 0xFE70 && codeUnit <= 0xFEFF) || // Arabic Presentation Forms-B
        (codeUnit >= 0x10E60 && codeUnit <= 0x10E7F)) {
      //  miraiPrint('Is text Arabic? true');
      // Arabic Extended-B
      return true;
    }
  }
  // miraiPrint('Is text Arabic? false');
  return false;
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void showDownloadNotification({
  required String title,
  required int progress,
}) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'download_channel',
    'Download Notifications',
    channelDescription: 'Notifications for file downloads',
    importance: Importance.high,
    priority: Priority.high,
    showProgress: progress != 100,
    maxProgress: 100,
    progress: progress,
  );

  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    ' جارى تحميل: $title',
    progress == 100 ? 'تم التحميل بنجاح' : '$progress%',
    platformChannelSpecifics,
  );
}

class FileChannel {
  static const MethodChannel _channel = MethodChannel('com.kotobati.pdf_reader_channel');

  // static Future<void> shareFile(
  //     {required Uint8List fileBytes,
  //     required String fileName,
  //     required String title,
  //     String? subject}) async {
  //   try {
  //     await _channel.invokeMethod('shareFile', {
  //       "fileBytes": fileBytes,
  //       "title": title,
  //       "subject": subject,
  //       "fileName": fileName,
  //     });
  //   } catch (e) {
  //     print('Error sharing file: $e');
  //   }
  // }

  static Future<void> shareFile(String filePath, String title, String? subject) async {
    try {
      await _channel
          .invokeMethod('shareFile', {"filePath": filePath, "title": title, "subject": subject});
    } catch (e) {
      print('Error sharing file: $e');
    }
  }
}

// Future<Uint8List> fileToUint8List(File file) async {
//   if (await file.exists()) {
//     final List<int> bytes = await file.readAsBytes();
//     return Uint8List.fromList(bytes);
//   } else {
//     throw const FileSystemException('File does not exist');
//   }
// }

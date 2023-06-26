import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  /// A Value Notifier to store chosen Book...
  final ValueNotifier<Book?> chosenBook = ValueNotifier<Book?>(null);

  // @override
  // void onInit() {
  //   super.onInit();
  // }
  //
  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {
    chosenBook.value = null;
    chosenBook.dispose();
    super.onClose();
  }

  Future<void> requestPermission() async {
    final PermissionStatus status = await Permission.storage.request();
    miraiPrint("PermissionStatus $status");
    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> onDownloadStartRequest(
    InAppWebViewController controller,
    DownloadStartRequest downloadStartRequest,
  ) async {
    await requestPermission();
    miraiPrint("<========================>");
    miraiPrint("DownloadStartRequest: ${downloadStartRequest.toString()}");
    String filename = extractFilename(downloadStartRequest.contentDisposition.toString());
    miraiPrint("DownloadStartRequest: filename $filename");
    miraiPrint("<========================>");
    miraiPrint("onDownloadStart URL ${downloadStartRequest.url.toString()}");
    miraiPrint("<========================>");
    //  Directory? directory = await getExternalStorageDirectory();
    // Directory? directory = Platform.isAndroid
    //     ? await getExternalStorageDirectory()
    //     : await getApplicationSupportDirectory();

    /// Create App Folder
    // The app name is:
    const String appName = 'Kotobati';
    final String path = await createFolder(appName);
    final Book book = chosenBook.value!;
    book.path = '$path/$filename';

    /// Save book to Hive
    final HiveDataStore dataStore = HiveDataStore();
    dataStore.saveBook(book: book);

    try {
      /// enqueue
      final String? taskId = await FlutterDownloader.enqueue(
        url: downloadStartRequest.url.toString(),
        savedDir: path,
        // show download progress in status bar (for Android)
        showNotification: true,
        // click on notification to open downloaded file (for Android)
        openFileFromNotification: true,
      );
      miraiPrint('FlutterDownloader taskId: $taskId');

      /// registerCallback
      await FlutterDownloader.registerCallback((
        String id,
        int status,
        int progress,
      ) {
        miraiPrint("FlutterDownloader: id $id, status: $status, progress: $progress");
      });


    } catch (ex) {
      miraiPrint("FlutterDownloader.enqueue Exception");
    }
  }

  /// If you name your createFolder(".folder") that folder will be hidden.
  /// If you create a .nomedia file in your folder, other apps won't be able to scan your folder.
  Future<String> createFolder(String cow) async {
    /// getExternalStorageDirectory For Android, and getApplicationSupportDirectory For iOS...
    final Directory dir = Directory(
      '${(Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationSupportDirectory())!.path}/$cow',
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

  // Future<void> downloadFile(String fileName, String url) async {
  //   Dio dio = Dio();
  //   Directory? dir = await getExternalStorageDirectory();
  //   Directory knockDir =
  //       await new Directory('${dir.path}/Kotobati').create(recursive: true);
  //   print(url);
  //   await dio.download(widget.url, '${knockDir.path}/${widget.fileName}.pdf',
  //       onProgress: (rec, total) {
  //     if (mounted) {
  //       setState(() {
  //         downloading = true;
  //         progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
  //       });
  //     }
  //   });
  //   // if (mounted) {
  //   //   setState(() {
  //   //     downloading = false;
  //   //     progressString = "Completed";
  //   //     _message = "File is downloaded to your SD card 'iLearn' folder!";
  //   //   });
  //   // }
  //   print("Download completed");
  // }

  Future<void> createAppFolder() async {
    await requestPermission();

    // Get the app name
    String appName = 'Kotobati';

    // Create a folder in internal storage
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    miraiPrint("App Directory ${directory?.toString()}");
    String appFolderPath = '${directory?.path}/$appName';
    Directory(appFolderPath).create(recursive: true);

    // Create a file path for the PDF
    // String pdfFilePath = '$appFolderPath/your_pdf_file';

    // Create a sample PDF file
    // createSamplePDF(pdfFilePath);

    // Check if the file was created
    // bool fileExists = await File(pdfFilePath).exists();
    // if (fileExists) {
    //   // ignore: use_build_context_synchronously
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Success'),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Text('PDF file saved successfully.'),
    //             Text('getTemporaryDirectory .${getTemporaryDirectory()}'),
    //             Text(
    //                 'getApplicationSupportDirectory .${getApplicationSupportDirectory()}'),
    //             Text(
    //                 'getApplicationDocumentsDirectory .${getApplicationDocumentsDirectory()}'),
    //             // Text('getApplicationDocumentsDirectory .${getAppl()}'),
    //             Text('App Folder Location:'),
    //             Text(appFolderPath),
    //           ],
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('OK'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //               // Open the folder containing the PDF file
    //               OpenFile.open("$pdfFilePath.pdf");
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }
}

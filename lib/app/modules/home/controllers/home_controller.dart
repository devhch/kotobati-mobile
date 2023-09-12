import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/download_task_info.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  /// A Value Notifier to store chosen Book...
  final ValueNotifier<Book?> chosenBook = ValueNotifier<Book?>(null);
  final ValueNotifier<DownloadTaskInfo?> downloadTaskInfo = ValueNotifier<DownloadTaskInfo?>(null);

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
    // chosenBook.value = null;
    // chosenBook.dispose();

    downloadTaskInfo.value = null;
    downloadTaskInfo.dispose();
    super.onClose();
  }

  Future<void> onDownloadStartRequest(
    InAppWebViewController controller,
    DownloadStartRequest downloadStartRequest,
  ) async {
    await requestPermission();
    final String downloadURL = downloadStartRequest.url.toString();
    miraiPrint("<========================>");
    miraiPrint("DownloadStartRequest: ${downloadStartRequest.toString()}");
    String filename =
        extractFilename(downloadStartRequest.contentDisposition.toString()).replaceAll('.pdf', '');
    miraiPrint("DownloadStartRequest: filename $filename");
    miraiPrint("onDownloadStart URL $downloadURL");
    miraiPrint("<========================>");

    miraiPrint('<==========================>');
    miraiPrint('ChosenBook in Controller: ${chosenBook.value}');

    /// Create App Folder
    final String path = await createFolder();
    final Book book = chosenBook.value!;
    book.path = '$path/$filename';

    /// Update Chosen Book
    chosenBook.value = book;
    chosenBook.notifyListeners();

    downloadTaskInfo.value = DownloadTaskInfo(name: book.title!, link: downloadURL);

    try {
      // enqueue
      final String? taskId = await FlutterDownloader.enqueue(
        url: downloadURL,
        savedDir: path,
        fileName: filename,
        // show download progress in status bar (for Android)
        showNotification: false,
        // click on notification to open downloaded file (for Android)
        openFileFromNotification: false,
        //  headers: {'auth': 'test_for_sql_encoding'},
      );
      miraiPrint('FlutterDownloader taskId: $taskId');
    } catch (ex) {
      miraiPrint("FlutterDownloader.enqueue Exception");
    }
  }
}

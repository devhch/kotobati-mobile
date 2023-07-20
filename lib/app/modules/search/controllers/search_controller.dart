import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:path_provider/path_provider.dart';

class SearchControllerC extends GetxController {
  late final TextEditingController txtController;

  List<FileSystemEntity> pdfFiles = [];

  @override
  void onInit() {
    txtController = TextEditingController();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    searchForPDFs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<FileSystemEntity> searchForPDFFiles(Directory directory) {
    List<FileSystemEntity> pdfFiles = [];
    directory.listSync(recursive: true).forEach((FileSystemEntity entity) {
      if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
        pdfFiles.add(entity);
      } else if (entity is Directory) {
        pdfFiles.addAll(searchForPDFFiles(entity));
      }
    });
    return pdfFiles;
  }

  Future<void> searchForPDFs() async {
    await requestPermission();

    Directory? appDirectory = await getExternalStorageDirectory();
    // Adjust as per your requirements
    List<FileSystemEntity> files = searchForPDFFiles(appDirectory!);

    pdfFiles = files;
    update();
  }
}

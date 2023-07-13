import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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
}

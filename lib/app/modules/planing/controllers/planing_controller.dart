import 'dart:io';

import 'package:get/get.dart';

class PlaningController extends GetxController {
  File? pdfFile;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      pdfFile = Get.arguments;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

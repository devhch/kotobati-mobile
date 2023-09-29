import 'dart:io';

import 'package:get/get.dart';
import 'package:kotobati/app/core/models/book_model.dart';

class BookDetailsController extends GetxController {
  Book? book;

  RxBool notes = false.obs;

  File? pdfFile;

  @override
  void onInit() {
    book = Get.arguments['book'];
    pdfFile = File(book!.path!.replaceAll('.pdf', ''));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    pdfFile = null;
    super.dispose();
  }

}

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
//     book.notes = <String>[
//       """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
// نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
//       """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
// نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
//       "tttttt tttttt tttttt tttttt tttttt tttttt tttttt",
//     ];
//     book.quotes = <String>[
//       """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
// نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي."""
//     ];
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

  void checkNotesAndStrings(List<String> notes) {
    List<String> checkedList = <String>[
      """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
      """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
      "tttttt tttttt tttttt tttttt tttttt tttttt tttttt",
    ];

    for (String item in checkedList) {
      if (notes.contains(item)) {
        notes.remove(item);
      }
    }
  }
}

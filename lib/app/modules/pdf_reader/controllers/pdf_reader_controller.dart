import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';

class PdfReaderController extends GetxController {
  String pdfPath = '';
  ValueNotifier<Book> book = ValueNotifier<Book>(Book());

//  late final PdfViewerController pdfViewerController;

  PDFViewController? pdfViewerController;

  File? pdfFile;

  /// Saved Page
  late ValueNotifier<(int, int)> savedPage;

  late ValueNotifier<bool> isPdfLoaded;

  late ValueNotifier<bool> isScrolling;

  late ValueNotifier<bool> isExpandedOptions;

  late ScrollController scrollController;

  bool isBack = false;
  bool isVertical = true;
  bool isDarkMode = false;
  double pagePadding = 10;

  @override
  void onInit() {
    isBack = false;
    book.value = Get.arguments;
    pdfPath = book.value.path!;
    //if (!pdfPath.contains('.pdf')) pdfPath += '.pdf';
    //  pdfViewerController = PdfViewerController();

    miraiPrint('PdfReaderController pdfPath: $pdfPath');
    pdfFile = File(pdfPath.replaceAll('.pdf', ''));
    miraiPrint('File Path: $pdfPath');
    miraiPrint('File Exists: ${pdfFile?.existsSync()}');

    savedPage = ValueNotifier<(int, int)>((0, 0));
    isPdfLoaded = ValueNotifier<bool>(false);
    isScrolling = ValueNotifier<bool>(false);
    isExpandedOptions = ValueNotifier<bool>(false);
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    update();
  }

  @override
  void dispose() {
    miraiPrint("PdfReaderController dispose");
    super.dispose();
  }

  @override
  void onClose() {
    // savedPage.dispose();
    // isPdfLoaded.dispose();
    // isScrolling.dispose();
    // isExpandedOptions.dispose();
    // pdfFile = null;
    // pdfPath = '';
    // miraiPrint("PdfReaderController dispose");
    super.onClose();
  }
}

void checkNotes(List<String> notes) {
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

void checkQuotes(List<String> notes) {
  List<String> checkedList = <String>[
    """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي."""
  ];

  for (String item in checkedList) {
    if (notes.contains(item)) {
      notes.remove(item);
    }
  }
}

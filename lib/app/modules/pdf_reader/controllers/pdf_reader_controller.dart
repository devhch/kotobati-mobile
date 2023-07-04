import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReaderController extends GetxController {
  late final String pdfPath;
  late final PdfViewerController pdfViewerController;
  late final GlobalKey<SfPdfViewerState> pdfViewerKey;

  @override
  void onInit() {
    pdfPath = Get.arguments['path'];
    pdfViewerController = PdfViewerController();
    pdfViewerKey = GlobalKey<SfPdfViewerState>();

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
}

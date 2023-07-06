import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReaderController extends GetxController {
  String pdfPath = '';
  late final PdfViewerController pdfViewerController;
  late final GlobalKey<SfPdfViewerState> pdfViewerKey;

  File? pdfFile;

  @override
  void onInit() {
    pdfPath = Get.arguments['path'];
    //if (!pdfPath.contains('.pdf')) pdfPath += '.pdf';
    pdfViewerController = PdfViewerController();
    pdfViewerKey = GlobalKey<SfPdfViewerState>();
    miraiPrint('PdfReaderController pdfPath: $pdfPath');
    pdfFile = File(pdfPath.replaceAll('.pdf', ''));
    print('File Path: $pdfPath');
    print('File Exists: ${pdfFile?.existsSync()}');
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

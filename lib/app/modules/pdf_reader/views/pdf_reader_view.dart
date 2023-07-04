import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../controllers/pdf_reader_controller.dart';

class PdfReaderView extends GetView<PdfReaderController> {
  const PdfReaderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PdfReaderController>(
      builder: (_) {
        return Scaffold(
          body: SfPdfViewer.file(
            File(controller.pdfPath),
            onTextSelectionChanged: (_) {},
            key: controller.pdfViewerKey,
            controller: controller.pdfViewerController,
            onDocumentLoaded: (_) {
              controller.update();
            },
          ),
        );
      },
    );
  }
}

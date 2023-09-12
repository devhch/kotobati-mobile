import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../controllers/pdf_reader_controller.dart';

class PdfReaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PdfReaderController(),
      fenix: true,
      tag: '${UniqueKey()}',
    );
  }
}

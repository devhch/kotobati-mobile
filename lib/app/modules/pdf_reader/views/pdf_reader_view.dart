import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pdf_reader_controller.dart';

class PdfReaderView extends GetView<PdfReaderController> {
  const PdfReaderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PdfReaderView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PdfReaderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

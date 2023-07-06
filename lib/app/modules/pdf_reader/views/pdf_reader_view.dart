import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_extension.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../controllers/pdf_reader_controller.dart';

class PdfReaderView extends GetView<PdfReaderController> {
  const PdfReaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PdfReaderController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.keyAppBlackColor,
          appBar: AppBar(
            backgroundColor: AppTheme.keyAppBarColor,
            title: SvgPicture.asset(AppIconsKeys.ktobatiIcon),
            centerTitle: true,
            toolbarHeight: 80,
            elevation: 2,
            leading: IconButton(
              icon: SvgPicture.asset(
                AppIconsKeys.settingPoint,
              ),
              onPressed: () {},
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.settings);
                },
                icon: SvgPicture.asset(AppIconsKeys.setting),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              // Container(
              //   decoration: BoxDecoration(),
              //   padding: EdgeInsets.only(top: context.topPadding),
              //   child: ,
              // ),
              if(controller.pdfFile != null)
              Expanded(
                child: SfPdfViewer.file(
                  //   'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                  File(controller.pdfFile!.path ),
                  onTextSelectionChanged: (_) {},
                  key: controller.pdfViewerKey,
                  controller: controller.pdfViewerController,
                  onDocumentLoaded: (_) {
                   // controller.update();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

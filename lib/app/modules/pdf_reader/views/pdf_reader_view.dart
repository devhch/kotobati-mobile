import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
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
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.settings);
                },
                icon: SvgPicture.asset(AppIconsKeys.setting),
              )
            ],
          ),
          body: (controller.pdfFile != null)
              ? Column(
                  children: <Widget>[
                    Expanded(
                      child: SfPdfViewer.file(
                        File(controller.pdfFile!.path),
                        onTextSelectionChanged: (_) {},
                        key: controller.pdfViewerKey,
                        controller: controller.pdfViewerController,
                        onDocumentLoaded: (_) {
                          // controller.update();
                        },
                        onPageChanged: (PdfPageChangedDetails details) {
                          miraiPrint('details.newPageNumber ${details.newPageNumber}');
                          miraiPrint('details.newPageNumber ${details.oldPageNumber}');
                          miraiPrint('details.newPageNumber ${details.isFirstPage}');
                          miraiPrint('details.newPageNumber ${details.isLastPage}');
                          miraiPrint(
                              'details.newPageNumber ${controller.pdfViewerController.pageCount}');
                          miraiPrint(
                              'details.newPageNumber ${controller.pdfViewerController.pageNumber}');
                        },
                      ),
                    ),
                    Container(
                      height: 78,
                      color: AppTheme.keyAppLightGrayColor,
                      child: ValueListenableBuilder<double>(
                        valueListenable: controller.savedPage,
                        builder: (_, double page, __) {
                          return Slider.adaptive(
                            value: page,
                            min: 1,
                            max: controller.pdfViewerController.pageCount.toDouble(),
                            label: '$page',
                            onChanged: (double newPage) {
                              controller.savedPage.value = newPage;
                            },
                          );
                        },
                      ),
                    )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.keyAppColor),
                    strokeWidth: 2,
                  ),
                ),
        );
      },
    );
  }
}

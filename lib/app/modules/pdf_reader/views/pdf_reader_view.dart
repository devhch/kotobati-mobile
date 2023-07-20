import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/pdf_reader/views/components/planing_bottom_sheet.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_verifying_dialog.dart';

import '../controllers/pdf_reader_controller.dart';
import 'components/app_bar_settings_action.dart';
import 'components/options_menu_widget.dart';
import 'components/options_widget.dart';
import 'components/slider_bottom_widget.dart';

class PdfReaderView extends StatefulWidget {
  const PdfReaderView({Key? key}) : super(key: key);

  @override
  State<PdfReaderView> createState() => _PdfReaderViewState();
}

class _PdfReaderViewState extends State<PdfReaderView> {
  /// PdfReaderController
  late PdfReaderController controller;

  late GlobalKey _menuKey;

  late GlobalKey _optionsMenuKey;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PdfReaderController>();
    _menuKey = GlobalKey();
    _optionsMenuKey = GlobalKey();
  }

  /// Variables

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PdfReaderController>(
      builder: (_) {
        miraiPrint('==================');
        miraiPrint('GetBuilder updated');
        miraiPrint('GetBuilder isDarkMode ${controller.isDarkMode}');
        miraiPrint('GetBuilder isVertical ${controller.isVertical}');
        miraiPrint('==================');
        return WillPopScope(
          onWillPop: () async {
          //  controller.isBack = true;
          //  controller.update();

            miraiPrint('PDFReader ${controller.book.value}');
            //Get.back<Book>(result: controller.book.value);

            miraiPrint('PDFReader Back');
            return true;
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              systemNavigationBarColor: controller.isBack
                  ? AppTheme.keyAppBlackColor
                  : AppTheme.keyAppLightGrayColor,
            ),
            child: Scaffold(
              backgroundColor: AppTheme.keyAppBlackColor,
              appBar: AppBar(
                backgroundColor: AppTheme.keyAppBarColor,
                title: SvgPicture.asset(AppIconsKeys.ktobatiIcon),
                centerTitle: true,
                toolbarHeight: 80,
                elevation: 2,
                leading: OptionsMenuWidget(
                  optionsMenuKey: _optionsMenuKey,
                  controller: controller,
                ),
                actions: <Widget>[
                  AppBarSettingsAction(menuKey: _menuKey, controller: controller),
                  const SizedBox(width: 10),
                ],
              ),
              body: (controller.pdfFile != null)
                  ? Column(
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: PDF(
                                  enableSwipe: true,
                                  swipeHorizontal: !controller.isVertical,
                                  autoSpacing: false,
                                  pageFling: false,
                                  nightMode: controller.isDarkMode,
                                  onViewCreated:
                                      (PDFViewController pdfViewerController) async {
                                    controller.pdfViewerController =
                                        pdfViewerController;

                                    final int? totalPages =
                                        await pdfViewerController.getPageCount();
                                    if (totalPages != null) {
                                      controller.savedPage.value = (0, totalPages);
                                      controller.isPdfLoaded.value = true;
                                    }
                                  },
                                  onError: (dynamic error) {
                                    miraiPrint(error.toString());
                                  },
                                  onPageError: (int? page, dynamic error) {
                                    miraiPrint('$page: ${error.toString()}');
                                  },   onRender: (int? page) {
                                    miraiPrint('onRender $page');
                                  },
                                  onPageChanged: (int? page, int? total) {
                                    miraiPrint('page change: $page/$total');
                                    if (page != null && total != null) {
                                      controller.savedPage.value = (page, total);
                                    }

                                    if (controller.isExpandedOptions.value) {
                                      controller.isExpandedOptions.value = false;
                                    }
                                  },
                                ).fromPath(controller.pdfFile!.path),
                              ),
                              // Container(
                              //   color: Colors.pink.withOpacity(0.2),
                              // ),
                              OptionsWidget(controller: controller),
                            ],
                          ),
                        ),
                        SliderBottomWidget(controller: controller)
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.keyAppColor),
                        strokeWidth: 2,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

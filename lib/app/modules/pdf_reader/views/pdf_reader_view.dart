import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/setting_objects_model.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/pdf_reader/views/components/planing_bottom_sheet.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_verifying_dialog.dart';
import 'package:screenshot/screenshot.dart';

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

class _PdfReaderViewState extends State<PdfReaderView> with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        miraiPrint('state resumed');
        SettingObjectsModel setting = await controller.hive.getSettingObjects();
        controller.setReadingMode(setting.brightness);
        break;
      case AppLifecycleState.inactive:
        miraiPrint('state inactive');
      case AppLifecycleState.paused:
        miraiPrint('state paused');
        controller.setReadingMode(controller.defaultBrightness);
      case AppLifecycleState.detached:
        miraiPrint('state detached');
        miraiPrint('state paused');
        controller.setReadingMode(controller.defaultBrightness);
        break;
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PdfReaderController>(
      init: controller,
      builder: (_) {
        miraiPrint('==================');
        miraiPrint('GetBuilder updated');
        miraiPrint('GetBuilder isDarkMode ${controller.isDarkMode}');
        miraiPrint('GetBuilder isVertical ${controller.isVertical}');
        miraiPrint('==================');
        rebuildAllChildren(context);
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
            value: const SystemUiOverlayStyle(
              systemNavigationBarColor: AppTheme.keyAppLightGrayColor,
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
                          child:  ValueListenableBuilder<bool>(
                              valueListenable: controller.isPaddingChanging,
                              builder: (_, bool isPaddingChanging, __) {
                              return Stack(
                                children: <Widget>[
                                  if (isPaddingChanging)
                                    Positioned.fill(
                                      child: ValueListenableBuilder<double>(
                                          valueListenable: controller.pagePadding,
                                          builder: (_, double pagePadding, __) {
                                          return AnimatedPadding(
                                            duration: const Duration(milliseconds: 100),
                                            padding:
                                                EdgeInsets.symmetric(horizontal: pagePadding),
                                            child: Screenshot(
                                              controller: controller.screenshotController,
                                              child: PDFView(
                                                filePath: controller.pdfFile!.path,
                                                enableSwipe: true,
                                                swipeHorizontal: !controller.isVertical,
                                                autoSpacing: false,
                                                 pageFling: false,
                                                nightMode: controller.isDarkMode,
                                                onViewCreated: onViewCreated,
                                                onError: onError,
                                                onPageError: onPageError,
                                                onRender: onRender,
                                                onPageChanged: onPageChanged,
                                              ),
                                            ),
                                          );
                                        }
                                      ),
                                    )
                                  else
                                    Positioned.fill(
                                      child: AnimatedPadding(
                                        duration: const Duration(milliseconds: 100),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: controller.pagePadding.value),
                                        child: Screenshot(
                                          controller: controller.screenshotController,
                                          child: MiraiCachedPDFWidget(controller: controller),
                                        ),
                                      ),
                                    ),
                                  OptionsWidget(controller: controller),
                                ],
                              );
                            }
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

  void onViewCreated(PDFViewController pdfViewerController) async {
    controller.pdfViewerController = pdfViewerController;

    final int? totalPages = await pdfViewerController.getPageCount();
    if (totalPages != null) {
      controller.savedPage.value = (0, totalPages);
      controller.isPdfLoaded.value = true;
    }
  }

  void onError(dynamic error) {
    miraiPrint(error.toString());
  }

  void onPageError(int? page, dynamic error) {
    miraiPrint('$page: ${error.toString()}');
  }

  void onRender(int? page) {
    miraiPrint('onRender $page');
  }

  void onPageChanged(int? page, int? total) {
    miraiPrint('page change: $page/$total');
    if (page != null && total != null) {
      controller.savedPage.value = (page, total);
    }

    if (controller.isExpandedOptions.value) {
      controller.isExpandedOptions.value = false;
    }
  }
}

class MiraiCachedPDFWidget extends StatelessWidget {
  const MiraiCachedPDFWidget({
    super.key,
    required this.controller,
  });

  final PdfReaderController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isVertical) {
      return PDFView(
        key: UniqueKey(),
        filePath: controller.pdfFile!.path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        // pageFling: false,
        nightMode: controller.isDarkMode,
        onViewCreated: onViewCreated,
        onError: onError,
        onPageError: onPageError,
        onRender: onRender,
        onPageChanged: onPageChanged,
      );
    } else if (controller.isDarkMode) {
      return PDFView(
        key: UniqueKey(),
        filePath: controller.pdfFile!.path,
        enableSwipe: true,
        swipeHorizontal: !controller.isVertical,
        autoSpacing: false,
        pageFling: false,
        nightMode: true,
        onViewCreated: onViewCreated,
        onError: onError,
        onPageError: onPageError,
        onRender: onRender,
        onPageChanged: onPageChanged,
      );
    } else if (!controller.isDarkMode) {
      return PDFView(
        key: UniqueKey(),
        filePath: controller.pdfFile!.path,
        enableSwipe: true,
        swipeHorizontal: !controller.isVertical,
        autoSpacing: false,
        pageFling: false,
        nightMode: false,
        onViewCreated: onViewCreated,
        onError: onError,
        onPageError: onPageError,
        onRender: onRender,
        onPageChanged: onPageChanged,
      );
    } else {
      return PDFView(
        key: UniqueKey(),
        filePath: controller.pdfFile!.path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        nightMode: controller.isDarkMode,
        onViewCreated: onViewCreated,
        onError: onError,
        onPageError: onPageError,
        onRender: onRender,
        onPageChanged: onPageChanged,
      );
    }
  }

  void onViewCreated(PDFViewController pdfViewerController) async {
    controller.pdfViewerController = pdfViewerController;

    final int? totalPages = await pdfViewerController.getPageCount();
    if (totalPages != null) {
      controller.savedPage.value = (0, totalPages);
      controller.isPdfLoaded.value = true;
    }
  }

  void onError(dynamic error) {
    miraiPrint(error.toString());
  }

  void onPageError(int? page, dynamic error) {
    miraiPrint('$page: ${error.toString()}');
  }

  void onRender(int? page) {
    miraiPrint('onRender $page');
  }

  void onPageChanged(int? page, int? total) {
    miraiPrint('page change: $page/$total');
    if (page != null && total != null) {
      controller.savedPage.value = (page, total);
    }

    if (controller.isExpandedOptions.value) {
      controller.isExpandedOptions.value = false;
    }
  }
}

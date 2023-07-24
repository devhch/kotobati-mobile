import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';

import 'package:kotobati/app/core/models/setting_objects_model.dart';
import 'package:kotobati/app/core/utils/app_extension.dart';

import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
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
  late GlobalKey<State> _screenshotKey;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PdfReaderController>();
    _menuKey = GlobalKey();
    _optionsMenuKey = GlobalKey();
    _screenshotKey = GlobalKey<State>();
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

        bool isActive = await FlutterOverlayWindow.isActive();
        if (isActive) {
          /// closes overlay if open
          await FlutterOverlayWindow.closeOverlay();
        }

      case AppLifecycleState.detached:
        miraiPrint('state detached');
        miraiPrint('state paused');
        controller.setReadingMode(controller.defaultBrightness);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.keyAppLightGrayColor,
      ),
      child: GetBuilder<PdfReaderController>(
        init: controller,
        builder: (_) {
          miraiPrint('==================');
          miraiPrint('GetBuilder updated');
          miraiPrint('GetBuilder isDarkMode ${controller.isDarkMode}');
          miraiPrint('GetBuilder isVertical ${controller.isVertical}');
          miraiPrint('==================');
          return Scaffold(
            backgroundColor: AppTheme.keyAppBlackColor,
            body: (controller.pdfFile != null)
                ? Column(
                    children: <Widget>[
                      ValueListenableBuilder<bool>(
                          valueListenable: controller.fullScreen,
                          builder: (_, bool fullScreen, __) {
                            return PdfReaderAppBarWidget(
                              optionsMenuKey: _optionsMenuKey,
                              controller: controller,
                              menuKey: _menuKey,
                              fullScreen: fullScreen,
                            );
                          }),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Screenshot(
                                controller: controller.screenshotController,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: controller.isPaddingChanging,
                                  builder: (_, bool isPaddingChanging, __) {
                                    return AnimatedSwitcher(
                                      duration: const Duration(seconds: 1),
                                      child: isPaddingChanging
                                          ? Column(
                                              key: ValueKey<String>(
                                                'SwitchingTrue${DateTime.now().toIso8601String()}',
                                              ),
                                              children: <Widget>[
                                                Expanded(
                                                  child: ValueListenableBuilder<double>(
                                                    valueListenable: controller.pagePadding,
                                                    builder: (_, double pagePadding, __) {
                                                      return Stack(
                                                        children: <Widget>[
                                                          AnimatedPositioned(
                                                            duration:
                                                                const Duration(milliseconds: 100),
                                                            top: 0,
                                                            bottom: 0,
                                                            left: -pagePadding,
                                                            right: -pagePadding,
                                                            child: MiraiPDFWidget(
                                                              key: const ValueKey<String>(
                                                                'MiraiPDFWidget',
                                                              ),
                                                              controller: controller,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                                ValueListenableBuilder<bool>(
                                                  valueListenable: controller.fullScreen,
                                                  builder: (_, bool fullScreen, __) {
                                                    if (!fullScreen && isPaddingChanging) {
                                                      return SliderBottomWidget(
                                                        controller: controller,
                                                      );
                                                    } else {
                                                      return const SizedBox.shrink();
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                          : Container(
                                              key: ValueKey<String>(
                                                'SwitchingFalse${DateTime.now().toIso8601String()}',
                                              ),
                                              color: AppTheme.keyAppBlackColor,
                                              child: const Center(
                                                child: CircularProgressIndicator.adaptive(
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    AppTheme.keyAppColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    );
                                    // : MiraiPDFWidget(controller: controller);
                                    // : PDFView(
                                    //     filePath: controller.pdfFile!.path,
                                    //     enableSwipe: true,
                                    //     swipeHorizontal: !controller.isVertical,
                                    //     autoSpacing: false,
                                    //     nightMode: controller.isDarkMode,
                                    //     onViewCreated: onViewCreated,
                                    //     onError: onError,
                                    //     onPageError: onPageError,
                                    //     onRender: onRender,
                                    //     onPageChanged: onPageChanged,
                                    //   );
                                  },
                                ),
                              ),
                            ),
                            OptionsWidget(controller: controller),
                            Positioned.fill(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: controller.isPdfLoaded,
                                builder: (_, bool isPdfLoaded, __) {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    switchInCurve: Curves.easeIn,
                                    switchOutCurve: Curves.easeInOutCubic,
                                    child: !isPdfLoaded
                                        ? Container(
                                            key: ValueKey<String>(
                                              'SwitchingFalse${DateTime.now().toIso8601String()}',
                                            ),
                                            color: AppTheme.keyAppLightGrayColor,
                                            child: const Center(
                                              child: CircularProgressIndicator.adaptive(
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  AppTheme.keyAppColor,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink(
                                            key: ValueKey<String>(
                                              'SwitchingSizedBox${DateTime.now().toIso8601String()}',
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),
                            ValueListenableBuilder<bool>(
                                valueListenable: controller.fullScreen,
                                builder: (_, bool fullScreen, __) {
                                  if (fullScreen) {
                                    return Padding(
                                      padding: EdgeInsetsDirectional.only(
                                        start: 20.0,
                                        top: context.topPadding + 10,
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: AppTheme.keyAppColorDark,
                                        child: Center(
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              controller.enterFullScreen();
                                              controller.fullScreen.value =
                                                  !controller.fullScreen.value;
                                              controller.fullScreen.notifyListeners();
                                            },
                                            highlightColor:
                                                AppTheme.keyAppBlackColor.withOpacity(.2),
                                            splashColor: AppTheme.keyAppBlackColor.withOpacity(.2),
                                            icon: const Icon(
                                              Icons.fullscreen_exit,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }),
                          ],
                        ),
                      ),
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
      ),
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

class PdfReaderAppBarWidget extends StatelessWidget {
  const PdfReaderAppBarWidget({
    super.key,
    required GlobalKey<State<StatefulWidget>> optionsMenuKey,
    required this.controller,
    required GlobalKey<State<StatefulWidget>> menuKey,
    required this.fullScreen,
  })  : _optionsMenuKey = optionsMenuKey,
        _menuKey = menuKey;

  final GlobalKey<State<StatefulWidget>> _optionsMenuKey;
  final PdfReaderController controller;
  final GlobalKey<State<StatefulWidget>> _menuKey;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: fullScreen
          ? const SizedBox.shrink()
          : AppBar(
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
                AppBarSettingsAction(
                  menuKey: _menuKey,
                  controller: controller,
                ),
                const SizedBox(width: 10),
              ],
            ),
    );
  }
}

class MiraiPDFWidget extends StatelessWidget {
  const MiraiPDFWidget({
    super.key,
    required this.controller,
  });

  final PdfReaderController controller;

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: controller.pdfFile!.path,
      enableSwipe: true,
      swipeHorizontal: !controller.isVertical,
      autoSpacing: false,
      nightMode: controller.isDarkMode,
      onViewCreated: onViewCreated,
      onError: onError,
      onPageError: onPageError,
      onRender: onRender,
      onPageChanged: onPageChanged,
    );
  }

  void onViewCreated(PDFViewController pdfViewerController) async {
    controller.pdfViewerController = pdfViewerController;

    final int? totalPages = await pdfViewerController.getPageCount();
    if (totalPages != null) {
      if (controller.savedPage.value.$2 == 0) {
        controller.savedPage.value = (0, totalPages);
      }

      if (!controller.isPdfLoaded.value) {
        await Future<void>.delayed(const Duration(milliseconds: 400), () {
          controller.isPdfLoaded.value = true;
          controller.isPdfLoaded.notifyListeners();
        });
      }
    }
  }

  void onError(dynamic error) {
    miraiPrint('PDFonError: $error');
    controller.isPdfLoaded.value = false;
    controller.isPdfLoaded.notifyListeners();
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_verifying_dialog.dart';

import '../controllers/pdf_reader_controller.dart';

class PdfReaderView extends StatefulWidget {
  const PdfReaderView({Key? key}) : super(key: key);

  @override
  State<PdfReaderView> createState() => _PdfReaderViewState();
}

class _PdfReaderViewState extends State<PdfReaderView> {
  /// PdfReaderController
  static final PdfReaderController controller = Get.find<PdfReaderController>();

  static final GlobalKey _menuKey = GlobalKey();
  static final GlobalKey _optionsMenuKey = GlobalKey();

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
            controller.isBack = true;
            controller.update();
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
                leading: Center(
                  child: PopupMenuButton<int>(
                    key: _optionsMenuKey,
                    elevation: 1,
                    offset: const Offset(-24, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0),
                      ),
                    ),
                    icon: SvgPicture.asset(
                      AppIconsKeys.settingPoint,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    color: AppTheme.keyAppLightGrayColor,
                    //  color: AppTheme.keyAppColorDark,
                    //  offset: Offset(1, -240),
                    position: PopupMenuPosition.under,
                    onSelected: (int index) {
                      switch (index) {
                        case 0:

                          /// Share File
                          break;

                        case 1:

                          /// Delete
                          MiraiVerifyingDialog.showDialog(
                            yes: () {},
                            yesText: '',
                            no: () {},
                            noText: '',
                          );
                          break;

                        case 2:

                          /// Add To
                          if (controller.pdfFile != null) {
                            Get.toNamed(
                              Routes.planing,
                              arguments: controller.pdfFile,
                            );
                          }

                          break;
                      }
                    },

                    itemBuilder: (_) {
                      return <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'شارك الملف',
                            style: Get.theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'حذف',
                            style: Get.theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.keyAppColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'أضف إلى...',
                            style: Get.theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ];
                    },
                  ),
                ),
                actions: <Widget>[
                  Center(
                    child: PopupMenuButton<int>(
                      key: _menuKey,
                      elevation: 1,
                      offset: const Offset(24, 0),
                      padding: const EdgeInsets.all(0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                      icon: SvgPicture.asset(
                        AppIconsKeys.setting,
                        fit: BoxFit.fill,
                      ),
                      color: AppTheme.keyAppLightGrayColor,
                      //  color: AppTheme.keyAppColorDark,
                      //  offset: Offset(1, -240),
                      position: PopupMenuPosition.under,
                      onSelected: (int index) {
                        // switch (index) {
                        //   case 0:
                        //     controller.selectedFilerStadium.value = null;
                        //     break;
                        //
                        //   case 1:
                        //     controller.selectedFilerStadium.value = false;
                        //     break;
                        //
                        //   case 2:
                        //     controller.selectedFilerStadium.value = true;
                        //     break;
                        // }
                        //
                        // controller.changeStadiumFilter();
                      },

                      itemBuilder: (_) {
                        return <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: StatefulBuilder(builder: (BuildContext context,
                                void Function(void Function()) setState) {
                              return InkWell(
                                onTap: () {
                                  controller.isVertical = !controller.isVertical;
                                  controller.update();
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.zero,
                                  padding: const EdgeInsets.all(10),
                                  color: AppTheme.keyMenuItemGrayColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'قلب الصفحة',
                                        style: Get.theme.textTheme.bodyText2!.copyWith(
                                            //  color: AppTheme.keyDarkBlueColor,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              controller.isVertical ? 'عمودي' : 'أفقي',
                                              style: Get.theme.textTheme.headlineSmall!
                                                  .copyWith(
                                                fontSize: 16,
                                                //  color: AppTheme.keyDarkBlueColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          RotatedBox(
                                            quarterTurns: controller.isVertical ? 0 : 1,
                                            child: SvgPicture.asset(
                                              AppIconsKeys.arrowBottom,
                                              fit: BoxFit.fill,
                                              height: 14,
                                              width: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: StatefulBuilder(builder: (BuildContext context,
                                void Function(void Function()) setState) {
                              return InkWell(
                                onTap: () {
                                  controller.isDarkMode = !controller.isDarkMode;
                                  controller.update();

                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.all(10),
                                  color: AppTheme.keyMenuItemGrayColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'وضع القراءة',
                                        style: Get.theme.textTheme.bodyText2!.copyWith(
                                            //  color: AppTheme.keyDarkBlueColor,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              controller.isDarkMode ? 'ليلي' : 'النهار',
                                              style: Get.theme.textTheme.headlineSmall!
                                                  .copyWith(
                                                fontSize: 16,
                                                //  color: AppTheme.keyDarkBlueColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          RotatedBox(
                                            quarterTurns: controller.isDarkMode ? 0 : 1,
                                            child: SvgPicture.asset(
                                              AppIconsKeys.arrowBottom,
                                              fit: BoxFit.fill,
                                              height: 14,
                                              width: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          PopupMenuItem<int>(
                            value: 2,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: StatefulBuilder(builder: (BuildContext context,
                                void Function(void Function()) setState) {
                              return Container(
                                margin: const EdgeInsets.only(top: 6),
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                ),
                                color: AppTheme.keyMenuItemGrayColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'هامش الصفحة',
                                      style: Get.theme.textTheme.bodyText2!.copyWith(
                                          //  color: AppTheme.keyDarkBlueColor,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    //     const SizedBox(height: 6),
                                    Slider.adaptive(
                                      value: controller.pagePadding,
                                      min: 0,
                                      max: 40,
                                      label: '${controller.pagePadding}',
                                      inactiveColor: AppTheme.keySliderInactiveColor,
                                      onChanged: (double newPadding) {
                                        controller.pagePadding = newPadding;
                                        controller.update();
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ];
                      },
                    ),
                  ),

                  // IconButton(
                  //   onPressed: () {
                  //     Get.toNamed(Routes.settings);
                  //   },
                  //   icon: SvgPicture.asset(
                  //     AppIconsKeys.setting,
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
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
                                    controller.pdfViewerController = pdfViewerController;

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
                                  },
                                  onPageChanged: (int? page, int? total) {
                                    miraiPrint('page change: $page/$total');
                                    if (page != null && total != null) {
                                      controller.savedPage.value = (page, total);
                                    }
                                  },
                                ).fromPath(controller.pdfFile!.path),
                              ),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: controller.isExpandedOptions,
                                  builder: (_, final bool isExpandedOptions, __) {
                                    return Row(
                                      children: <Widget>[
                                        AnimatedContainer(
                                          height: 240,
                                          duration: const Duration(milliseconds: 1000),
                                          padding: isExpandedOptions
                                              ? const EdgeInsets.symmetric(horizontal: 8)
                                              : null,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.keyAppLightGrayColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(48),
                                              bottomLeft: Radius.circular(48),
                                            ),
                                          ),
                                          child: AnimatedSize(
                                            duration: const Duration(milliseconds: 100),
                                            child: isExpandedOptions
                                                ? Column(
                                                    key: UniqueKey(),
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      const SizedBox(height: 36),
                                                      SvgPicture.asset(
                                                        AppIconsKeys.idea,
                                                        height: 38,
                                                        width: 24,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      const SizedBox(height: 18),
                                                      Container(
                                                        height: 1,
                                                        color:
                                                            AppTheme.keyAppGrayColorDark,
                                                        width: 48,
                                                      ),
                                                      const SizedBox(height: 18),
                                                      Image.asset(
                                                        AppIconsKeys.file,
                                                        height: 26,
                                                        width: 22,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      const SizedBox(height: 18),
                                                      Container(
                                                        height: 1,
                                                        color:
                                                            AppTheme.keyAppGrayColorDark,
                                                        width: 48,
                                                      ),
                                                      const SizedBox(height: 18),
                                                      SvgPicture.asset(
                                                        AppIconsKeys.edit,
                                                        height: 26,
                                                        width: 28,
                                                        //    color: AppTheme.keyIconsGreyColor,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      const SizedBox(height: 36),
                                                    ],
                                                  )
                                                : SizedBox.shrink(
                                                    key: UniqueKey(),
                                                  ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            controller.isExpandedOptions.value =
                                                !controller.isExpandedOptions.value;

                                            // if (controller.isExpandedOptions.value) {
                                            //   animationController.forward();
                                            // } else {
                                            //   animationController.reverse();
                                            // }
                                          },
                                          child: Container(
                                            width: 26,
                                            height: 98,
                                            // padding: const EdgeInsets.symmetric(
                                            //   horizontal: 40,
                                            //   vertical: 2,
                                            // ),
                                            decoration: const BoxDecoration(
                                              color: AppTheme.keyAppGrayColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(26),
                                                bottomLeft: Radius.circular(26),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: RotatedBox(
                                              quarterTurns: -1,
                                              child: SvgPicture.asset(
                                                AppIconsKeys.arrowBottom,
                                                color: AppTheme.keyAppBlackColor,
                                                width: 10,
                                                height: 10,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: SfPdfViewer.file(
                        //     File(controller.pdfFile!.path),
                        //     canShowScrollStatus: false,
                        //     onTextSelectionChanged: (_) {},
                        //     key: controller.pdfViewerKey,
                        //     controller: controller.pdfViewerController,
                        //     onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                        //       controller.isPdfLoaded.value = true;
                        //
                        //       // controller.update();
                        //     },
                        //     onDocumentLoadFailed: (_) {},
                        //     onPageChanged: (PdfPageChangedDetails details) {
                        //       miraiPrint('details.newPageNumber ${details.newPageNumber}');
                        //       miraiPrint('details.oldPageNumber ${details.oldPageNumber}');
                        //       miraiPrint('details.isFirstPage ${details.isFirstPage}');
                        //       miraiPrint('details.isLastPage ${details.isLastPage}');
                        //       miraiPrint(
                        //         'details.pageCount ${controller.pdfViewerController.pageCount}',
                        //       );
                        //       miraiPrint(
                        //         'details.pageNumber ${controller.pdfViewerController.pageNumber}',
                        //       );
                        //       controller.savedPage.value =
                        //           controller.pdfViewerController.pageNumber.toDouble();
                        //     },
                        //   ),
                        // ),
                        ValueListenableBuilder<bool>(
                            valueListenable: controller.isPdfLoaded,
                            builder: (_, bool isPdfLoaded, __) {
                              if (isPdfLoaded) {
                                return Container(
                                  // height: 78,
                                  color: AppTheme.keyAppLightGrayColor,
                                  child: ValueListenableBuilder<(int, int)>(
                                    valueListenable: controller.savedPage,
                                    builder: (_, (int, int) savedPage, __) {
                                      final (int page, int total) = savedPage;
                                      return Column(
                                        children: <Widget>[
                                          const SizedBox(height: 16),
                                          Slider.adaptive(
                                            value: page.toDouble(),
                                            min: 0,
                                            max: total.toDouble(),
                                            label: '$page',
                                            inactiveColor:
                                                AppTheme.keySliderInactiveColor,
                                            onChanged: (double newPage) {
                                              controller.savedPage.value =
                                                  (newPage.toInt(), total);
                                              controller.pdfViewerController
                                                  ?.setPage(newPage.toInt());
                                            },
                                          ),
                                          Text(
                                            '${page + 1}/$total',
                                            style:
                                                Get.theme.textTheme.bodyLarge?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            })
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

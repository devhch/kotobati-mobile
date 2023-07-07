import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/routes/app_pages.dart';

import '../controllers/pdf_reader_controller.dart';

class PdfReaderView extends StatefulWidget {
  const PdfReaderView({Key? key}) : super(key: key);

  @override
  State<PdfReaderView> createState() => _PdfReaderViewState();
}

class _PdfReaderViewState extends State<PdfReaderView>   {
  /// PdfReaderController
  static final PdfReaderController controller = Get.find<PdfReaderController>();


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
                fit: BoxFit.fill,
                height: 20,
              ),
              onPressed: () {},
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.settings);
                },
                icon: SvgPicture.asset(
                  AppIconsKeys.setting,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: (controller.pdfFile != null)
              ? Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children:  <Widget>[
                        Positioned.fill(
                          child: PDF(
                            enableSwipe: true,
                            // swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: false,
                            // nightMode: true,
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
                                    child: AnimatedSize(  duration: const Duration(milliseconds: 100),
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
                                            color: AppTheme.keyAppGrayColorDark,
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
                                            color: AppTheme.keyAppGrayColorDark,
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
                                          :  SizedBox.shrink(key: UniqueKey(),),
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
        );
      },
    );
  }
}

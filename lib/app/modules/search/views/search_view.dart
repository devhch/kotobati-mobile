import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/mirai_pdf_model.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_extension.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:kotobati/app/widgets/mirai_text_field_widget.dart';
import 'package:kotobati/app/widgets/sliver_app_bar_delegate.dart';
import 'package:wave_linear_progress_indicator/wave_linear_progress_indicator.dart';

import '../controllers/search_controller.dart';
import 'components/search_pdf_item_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late SearchControllerC controller;

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SearchControllerC>();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  final GlobalKey keySearchWidget = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.keyAppBlackColor,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.keyAppBlackColor,
        resizeToAvoidBottomInset: false,
        body: GetBuilder<SearchControllerC>(
          init: controller,
          builder: (_) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: controller.pdfPaths.isNotEmpty
                  ? CustomScrollView(
                      key: ValueKey<String>("SearchViewColumn${DateTime.now().toIso8601String()}"),
                      slivers: <Widget>[
                        SliverToBoxAdapter(child: SizedBox(height: context.topPadding + 20)),

                        SliverPersistentHeader(
                          //pinned: true,
                          delegate: SliverAppBarDelegate(
                            minHeight: 70,
                            maxHeight: 70,
                            child: SearchTextFieldWidget(
                              // key: keySearchWidget,
                              controller: controller,
                              textEditingController: textEditingController,
                            ),
                          ),
                        ),

                        // SliverToBoxAdapter(
                        //   child: SearchTextFieldWidget(
                        //     controller: controller,
                        //     textEditingController: textEditingController,
                        //   ),
                        // ),
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                        const SearchHistoryValueListenable(),
                        if (controller.isPDFsFromHive)
                          PdfFilesFromHive(controller: controller)
                        else
                          PdfFilesFromDevice(controller: controller),
                        // SliverList(
                        //   padding: EdgeInsets.zero,
                        //   addAutomaticKeepAlives: true,
                        //   cacheExtent: double.infinity,
                        //   children: <Widget>[
                        //     const SearchHistoryValueListenable(),
                        //     if (controller.isPDFsFromHive)
                        //       PdfFilesFromHive(controller: controller)
                        //     else
                        //       PdfFilesFromDevice(controller: controller),
                        //   ],
                        // ),
                      ],
                    )
                  : controller.isDoneSearching
                      ? const SearchNoDataWidget()
                      : GetPdfFilesWidget(controller: controller),
            );
          },
        ),
      ),
    );
  }
}

class SearchTextFieldWidget extends StatelessWidget {
  const SearchTextFieldWidget({
    super.key,
    required this.controller,
    required this.textEditingController,
  });

  final SearchControllerC controller;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          iconSize: 55,
          splashRadius: 2,
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(AppIconsKeys.backArrowCircle),
        ),
        //  const Spacer(),
        Expanded(
          child: MiraiTextFieldWidget(
            controller: textEditingController,
            hint: "بحث...",
            // textFieldHeight: 40,

            style: Get.theme.textTheme.bodyLarge!.copyWith(
              color: AppTheme.keyAppBlackColor,
              fontWeight: FontWeight.w600,
            ),
            hintStyle: Get.theme.textTheme.bodyLarge!.copyWith(
              color: AppTheme.keyHintGreyColor,
              fontWeight: FontWeight.bold,
            ),
            fillColor: const Color(0xffA1A1A1),
            borderColor: const Color(0xffA1A1A1),
            //onChanged: controller.search,
            onFieldSubmitted: (String query) async {
              // if (query.isNotEmpty) {
              //   controller.search(query);
              //   await HiveDataStore().saveSearchHistory(query: query);
              // }
            },
          ),
        ),
        IconButton(
          iconSize: 55,
          splashRadius: 2,
          onPressed: () async {
            // if (controller.txtController.text.isNotEmpty) {
            //   await HiveDataStore().saveSearchHistory(query: controller.txtController.text);
            // }
          },
          icon: SvgPicture.asset(AppIconsKeys.search),
        ),
      ],
    );
  }
}

class GetPdfFilesWidget extends StatelessWidget {
  const GetPdfFilesWidget({
    super.key,
    required this.controller,
  });

  final SearchControllerC controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: ValueKey<String>(
        "SearchViewCenter${DateTime.now().toIso8601String()}",
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: (controller.total == 0 || controller.total == 1)
              ? Column(
                  key: ValueKey<String>(
                    "ColumnWhileDownloading${DateTime.now().toIso8601String()}",
                  ),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // const CircularProgressIndicator(),
                    // const SizedBox(height: 20),
                    Text(
                      'محاولة تحميل جميع ملفات\n pdf من الجهاز',
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      ' يرجى التحلي بالصبر لأن العملية\n قد تستغرق وقت...',
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    DefaultTextStyle(
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 30.0,
                      ),
                      child: AnimatedTextKit(
                        key: const ValueKey<int>(0),
                        totalRepeatCount: 30,
                        animatedTexts: <TypewriterAnimatedText>[
                          TypewriterAnimatedText(
                            'جاري التحميل...',
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SearchProgressWidget(controller: controller),
        ),
      ),
    );
  }
}

class SearchProgressWidget extends StatelessWidget {
  const SearchProgressWidget({
    super.key,
    required this.controller,
  });

  final SearchControllerC controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      key: ValueKey<String>(
        "ValueListenableBuilderWhileDownloading${DateTime.now().toIso8601String()}",
      ),
      valueListenable: controller.downloadProgress,
      builder: (_, int downloadProgress, __) {
        final double progress = downloadProgress / (controller.total != 0 ? controller.total : 1);

        if (progress == 0) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'يتم تحميل ${controller.total} كتاب من الجهاز',
                style: context.textTheme.displayLarge!.copyWith(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              WaveLinearProgressIndicator(
                value: progress,
                enableBounceAnimation: false,
                waveColor: AppTheme.keyAppColor,
                color: AppTheme.keyAppColor,
                borderRadius: 30,
                labelDecoration: BoxDecoration(
                  color: AppTheme.keyAppColorDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                waveBackgroundColor: AppTheme.keyAppColorDark,
                backgroundColor: Colors.grey[400],
                // minHeight: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}

class SearchNoDataWidget extends StatelessWidget {
  const SearchNoDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      key: ValueKey<String>("SearchCenterNoData${DateTime.now().toIso8601String()}"),
      child: Text(
        'لاتوجد بيانات',
        style: context.textTheme.displayLarge!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class PdfFilesFromDevice extends StatelessWidget {
  const PdfFilesFromDevice({
    super.key,
    required this.controller,
  });

  final SearchControllerC controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MiraiPDF>>(
        valueListenable: controller.pdfFilesForSearch,
        builder: (_, List<MiraiPDF> pdfFilesForSearch, __) {
          if (pdfFilesForSearch.isNotEmpty) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final MiraiPDF pdf = pdfFilesForSearch[index];
                  return SearchPDFItemWidget(
                    pdfWidthImage: pdf,
                    controller: controller,
                  );
                },
                childCount: pdfFilesForSearch.length,
              ),
            );

            // return ListView.builder(
            //   shrinkWrap: true,
            //   addAutomaticKeepAlives: true,
            //   cacheExtent: double.infinity,
            //   physics: const NeverScrollableScrollPhysics(),
            //   padding: EdgeInsets.zero,
            //   itemCount: pdfFilesForSearch.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     final MiraiPDF pdf = pdfFilesForSearch[index];
            //     return SearchPDFItemWidget(
            //       pdfWidthImage: pdf,
            //       controller: controller,
            //     );
            //   },
            // );
          } else {
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Text(
                    'لم يتم العثور على كتاب\n مثل هذا في جهازك.',
                    style: context.textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}

class PdfFilesFromHive extends StatelessWidget {
  const PdfFilesFromHive({
    super.key,
    required this.controller,
  });

  final SearchControllerC controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Map<dynamic, dynamic>>>(
      valueListenable: HiveDataStore().miraiPDFsListenable(),
      builder: (_, Box<Map<dynamic, dynamic>> box, __) {
        final List<Map<dynamic, dynamic>> miraiPDFs = box.values.toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final MiraiPDF pdf = MiraiPDF.fromJson(miraiPDFs[index]);
              return SearchPDFItemWidget(
                pdfWidthImage: pdf,
                controller: controller,
              );
            },
            childCount: miraiPDFs.length,
          ),
        );

        // return ListView.builder(
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   padding: EdgeInsets.zero,
        //   itemCount: miraiPDFs.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     final MiraiPDF pdf = MiraiPDF.fromJson(miraiPDFs[index]);
        //     return SearchPDFItemWidget(
        //       pdfWidthImage: pdf,
        //       controller: controller,
        //     );
        //   },
        // );
      },
    );
  }
}

class SearchHistoryValueListenable extends StatelessWidget {
  const SearchHistoryValueListenable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<String>>(
      valueListenable: HiveDataStore().searchHistoryListenable(),
      builder: (_, Box<String> box, __) {
        final List<String> searchHistory = box.values.toList();

        if (searchHistory.isNotEmpty) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        AppIconsKeys.time,
                        width: 18,
                        height: 18,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          searchHistory[index],
                          style: context.textTheme.displayLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          // textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'كتب',
                        style: context.textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
              childCount: searchHistory.length,
            ),
          );

          // return ListView.builder(
          //   shrinkWrap: true,
          //   addAutomaticKeepAlives: true,
          //   cacheExtent: double.infinity,
          //   physics: const NeverScrollableScrollPhysics(),
          //   padding: const EdgeInsets.only(
          //     top: 20,
          //     left: 34,
          //     right: 34,
          //     bottom: 20,
          //   ),
          //   itemCount: searchHistory.length,
          //   itemBuilder: (_, int index) {
          //     return Padding(
          //       padding: const EdgeInsets.only(bottom: 20),
          //       child: Row(
          //         children: <Widget>[
          //           SvgPicture.asset(
          //             AppIconsKeys.time,
          //             width: 18,
          //             height: 18,
          //             fit: BoxFit.fill,
          //           ),
          //           const SizedBox(width: 12),
          //           Expanded(
          //             child: Text(
          //               searchHistory[index],
          //               style: context.textTheme.displayLarge!.copyWith(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 16,
          //               ),
          //               // textAlign: TextAlign.center,
          //             ),
          //           ),
          //           const SizedBox(width: 12),
          //           Text(
          //             'كتب',
          //             style: context.textTheme.displayLarge!.copyWith(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 16,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // );
        } else {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
      },
    );
  }
}

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
import 'package:wave_linear_progress_indicator/wave_linear_progress_indicator.dart';

import '../controllers/search_controller.dart';
import 'components/search_pdf_item_widget.dart';

class SearchView extends GetView<SearchControllerC> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.keyAppBlackColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: AppTheme.keyAppBlackColor,
        ),
        child: GetBuilder<SearchControllerC>(
          init: controller,
          builder: (_) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: controller.pdfPaths.isNotEmpty
                  ? Column(
                      key: ValueKey<String>("SearchViewColumn${DateTime.now().toIso8601String()}"),
                      children: <Widget>[
                        SizedBox(height: context.topPadding + 20),
                        Row(
                          children: <Widget>[
                            IconButton(
                              iconSize: 55,
                              splashRadius: 2,
                              onPressed: () {
                                Get.back();
                              },
                              icon: SvgPicture.asset(AppIconsKeys.backArrowCircle),
                            ),
                            Expanded(
                              child: MiraiTextFieldWidget(
                                controller: controller.txtController,
                                hint: "بحث...",
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
                                onChanged: controller.search,
                                onFieldSubmitted: (String query) async {
                                  if (query.isNotEmpty) {
                                    await HiveDataStore().saveSearchHistory(query: query);
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              iconSize: 55,
                              splashRadius: 2,
                              onPressed: () async {
                                if (controller.txtController.text.isNotEmpty) {
                                  await HiveDataStore()
                                      .saveSearchHistory(query: controller.txtController.text);
                                }
                              },
                              icon: SvgPicture.asset(AppIconsKeys.search),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              ValueListenableBuilder<Box<String>>(
                                valueListenable: HiveDataStore().searchHistoryListenable(),
                                builder: (_, Box<String> box, __) {
                                  final List<String> searchHistory = box.values.toList();

                                  if (searchHistory.isNotEmpty) {
                                    return SizedBox(
                                      // height: 200,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 34,
                                          right: 34,
                                          bottom: 20,
                                        ),
                                        itemCount: searchHistory.length,
                                        itemBuilder: (_, int index) {
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
                                      ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                              if (controller.isPDFsFromHive)
                                ValueListenableBuilder<Box<Map<dynamic, dynamic>>>(
                                  valueListenable: HiveDataStore().booksListenable(),
                                  builder: (_, Box<Map<dynamic, dynamic>> box, __) {
                                    final List<Map<dynamic, dynamic>> miraiPDFs =
                                        box.values.toList();

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: miraiPDFs.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final MiraiPDF pdf = MiraiPDF.fromJson(miraiPDFs[index]);
                                        return SearchPDFItemWidget(
                                          pdfWidthImage: pdf,
                                          controller: controller,
                                        );
                                      },
                                    );
                                  },
                                )
                              else
                                ValueListenableBuilder<List<MiraiPDF>>(
                                    valueListenable: controller.pdfFilesForSearch,
                                    builder: (_, List<MiraiPDF> pdfFilesForSearch, __) {
                                      if (pdfFilesForSearch.isNotEmpty) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: pdfFilesForSearch.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            final MiraiPDF pdf = pdfFilesForSearch[index];
                                            return SearchPDFItemWidget(
                                              pdfWidthImage: pdf,
                                              controller: controller,
                                            );
                                          },
                                        );
                                      } else {
                                        return Center(
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
                                        );
                                      }
                                    }),
                            ],
                          ),
                        ),
                      ],
                    )
                  : controller.isDoneSearching
                      ? Center(
                          key: ValueKey<String>(
                              "SearchCenterNoData${DateTime.now().toIso8601String()}"),
                          child: Text(
                            'لاتوجد بيانات',
                            style: context.textTheme.displayLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        )
                      : Center(
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
                                            totalRepeatCount: 20,
                                            animatedTexts: <TypewriterAnimatedText>[
                                              TypewriterAnimatedText(
                                                'جاري التحميل...',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : ValueListenableBuilder<int>(
                                      key: ValueKey<String>(
                                        "ValueListenableBuilderWhileDownloading${DateTime.now().toIso8601String()}",
                                      ),
                                      valueListenable: controller.downloadProgress,
                                      builder: (_, int downloadProgress, __) {
                                        final double progress = downloadProgress /
                                            (controller.total != 0 ? controller.total : 1);

                                        if (progress == 0) return const SizedBox.shrink();
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20, right: 20, top: 40),
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
                                    ),
                            ),
                          ),
                        ),
            );
          },
        ),
      ),
    );
  }
}

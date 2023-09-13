/*
* Created By Mirai Devs.
* On 24/7/2023.
*/

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/mirai_pdf_model.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/pdf_reader/views/components/planing_bottom_sheet.dart';
import 'package:kotobati/app/modules/search/controllers/search_controller.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_container_widget.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:pdfx/pdfx.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class SearchPDFItemWidget extends StatefulWidget {
  const SearchPDFItemWidget({
    super.key,
    required this.pdfWidthImage,
    required this.controller,
  });

  final MiraiPDF pdfWidthImage;
  final SearchPDFController controller;

  @override
  State<SearchPDFItemWidget> createState() => _SearchPDFItemWidgetState();
}

class _SearchPDFItemWidgetState extends State<SearchPDFItemWidget> {
  @override
  Widget build(BuildContext context) {
    /// Generate Book...
    final String id = const Uuid().v1();
    final Book book = Book(
      id: id,
      title: widget.pdfWidthImage.title,
      path: widget.pdfWidthImage.path,
      image: widget.pdfWidthImage.image,
    );
    // log('MiraiPDF ${widget.pdfWidthImage.toString()}');

    //HiveDataStore().clearMiraiPDFs();
    return MiraiContainerWidget(
      backgroundColor: Colors.transparent,
      border: Border.all(
        color: AppTheme.keyAppGrayColorDark,
      ),
      margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
      height: 160,
      padding: EdgeInsets.zero,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            height: 160,
            child: widget.pdfWidthImage.image != null
                ? Container(
                    color: Colors.white,
                    child: Image.memory(
                      widget.pdfWidthImage.image!,
                      fit: BoxFit.fill,
                    ),
                  )
                : Shimmer.fromColors(
                    highlightColor: AppTheme.highlightColorShimmer,
                    baseColor: AppTheme.baseColorShimmer,
                    child: Container(
                      decoration: const BoxDecoration(
                        // shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.pdfWidthImage.title,
                  style: context.textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  textDirection:
                      isArabic(widget.pdfWidthImage.title) ? TextDirection.rtl : TextDirection.ltr,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.pdfWidthImage.size,
                  style: context.textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MiraiElevatedButtonWidget(
                        onTap: () {
                          miraiPrint('Selected PDF file: ${widget.pdfWidthImage.path}');

                          Get.toNamed(
                            Routes.pdfReader,
                            arguments: book,
                          );
                        },
                        rounded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                        overlayColor: Colors.white.withOpacity(.2),
                        child: Text(
                          'تفحص الكتاب',
                          style: context.textTheme.displayLarge!.copyWith(
                            color: AppTheme.keyAppBlackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MiraiElevatedButtonWidget(
                        onTap: () async {
                          AppMiraiDialog.miraiDialogBar(
                            title: ' يرجى الانتظار لحظة من فضلك ...',
                          );
                          miraiPrint('<=========================================>');
                          log('You are going to save this book ${book.toString()}');
                          if (book.image == null) {
                            AppMiraiDialog.miraiDialogBar(
                              title: 'محاولة إنشاء غلاف الكتاب. يرجى الانتظار لحظة من فضلك ...',
                            );
                            book.image = await widget.controller.generatePdfCover(book.path!);

                            /// Close Dialog...
                            Get.back();
                          }

                          List<int> yourFileBytes =
                              await widget.controller.readFileBytes(book.path!);
                          miraiPrint('yourFileBytes: $yourFileBytes');

                          if (yourFileBytes.isNotEmpty) {
                            String newPath = await widget.controller
                                .saveFileToDevice(book.title!, yourFileBytes);

                            book.path = newPath;
                          }

                          Get.back();

                          miraiPrint('<=========================================>');
                          log('You are going to save this book ${book.toString()}');

                          miraiPrint('<=========================================>');
                          PlaningBottomSheet.show(book: book);
                        },
                        rounded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                        overlayColor: Colors.white.withOpacity(.2),
                        child: Text(
                          'أضف إلى...',
                          style: context.textTheme.displayLarge!.copyWith(
                            color: AppTheme.keyAppBlackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

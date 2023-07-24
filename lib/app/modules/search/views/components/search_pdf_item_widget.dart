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
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/modules/pdf_reader/views/components/planing_bottom_sheet.dart';
import 'package:kotobati/app/modules/search/controllers/search_controller.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_container_widget.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:pdfx/pdfx.dart';
import 'package:shimmer/shimmer.dart';

class SearchPDFItemWidget extends StatefulWidget {
  const SearchPDFItemWidget({
    super.key,
    required this.pdfWidthImage,
    required this.controller,
  });

  final PdfWidthImage pdfWidthImage;
  final SearchControllerC controller;

  @override
  State<SearchPDFItemWidget> createState() => _SearchPDFItemWidgetState();
}

class _SearchPDFItemWidgetState extends State<SearchPDFItemWidget> {
  @override
  void initState() {
    super.initState();
    //  getCoverOfThePDF();
  }

  void getCoverOfThePDF() {
    if (widget.pdfWidthImage.image?.value == null) {
      // From file (Android, Ios, MacOs)
      PdfDocument.openFile(widget.pdfWidthImage.path).then((PdfDocument document) {
        document.getPage(1).then((PdfPage page) {
          page
              .render(
            // rendered image width resolution, required
            width: page.width * 2,
            // rendered image height resolution, required
            height: page.height * 2,

            // Rendered image compression format, also can be PNG, WEBP*
            // Optional, default: PdfPageImageFormat.PNG
            // Web not supported
            format: PdfPageImageFormat.png,

            // Image background fill color for JPEG
            // Optional, default '#ffffff'
            // Web not supported
            backgroundColor: '#ffffff',

            // Crop rect in image for render
            // Optional, default null
            // Web not supported
            // cropRect: Rect.fromLTRB(left, top, right, bottom),
          )
              .then((PdfPageImage? image) {
            widget.pdfWidthImage.image?.value = image!.bytes;
          });
        });
      });

      widget.pdfWidthImage.image?.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Generate Book...
    Book book = Book(
      title: widget.pdfWidthImage.title,
      path: widget.pdfWidthImage.path,
      image: widget.pdfWidthImage.image?.value,
    );
    return MiraiContainerWidget(
      backgroundColor: Colors.transparent,
      // onTap: () {
      //   // Implement the action when tapping on a file, e.g., open the PDF file.
      //   // You can use a PDF viewer plugin like 'flutter_pdfview' to display the PDF.
      //   // For this example, we'll simply print the file path.
      //   miraiPrint('Selected PDF file: ${widget.pdfWidthImage.path}');
      //   Book book = Book(
      //     title: title,
      //     path: widget.pdfWidthImage.path,
      //   );
      //   Get.toNamed(
      //     Routes.pdfReader,
      //     arguments: book,
      //   );
      // },
      border: Border.all(
        color: AppTheme.keyAppGrayColorDark,
      ),
      margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
      height: 160,
      padding: EdgeInsets.zero,
      // borderRadius: const BorderRadius.only(
      //   topLeft: Radius.circular(28),
      // ),
      child: Row(
        children: <Widget>[
          //  if (pdfController != null)
          SizedBox(
            width: 100,
            height: 160,
            // child: PdfView(
            //   controller: pdfController!,
            //   onDocumentLoaded: (document) {},
            //   onPageChanged: (page) {},
            // ),
            child: ValueListenableBuilder<Uint8List?>(
                valueListenable: widget.pdfWidthImage.image!,
                builder: (_, Uint8List? image, __) {
                  return image != null
                      ? Container(
                          color: Colors.white,
                          child: Image.memory(
                            image,
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
                        );
                }),
            // : const Center(child: CircularProgressIndicator()),
            // child: PDFView(
            //   filePath: widget.path,
            //   enableSwipe: false,
            //   swipeHorizontal: false,
            //   autoSpacing: false,
            //   nightMode: false,
            // ),
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

  bool isArabic(String text) {
    for (int codeUnit in text.runes) {
      if ((codeUnit >= 0x0600 && codeUnit <= 0x06FF) || // Arabic
          (codeUnit >= 0x0750 && codeUnit <= 0x077F) || // Arabic Supplement
          (codeUnit >= 0x08A0 && codeUnit <= 0x08FF) || // Arabic Extended-A
          (codeUnit >= 0xFB50 && codeUnit <= 0xFDFF) || // Arabic Presentation Forms-A
          (codeUnit >= 0xFE70 && codeUnit <= 0xFEFF) || // Arabic Presentation Forms-B
          (codeUnit >= 0x10E60 && codeUnit <= 0x10E7F)) {
        miraiPrint('Is text Arabic? true');
        // Arabic Extended-B
        return true;
      }
    }
    miraiPrint('Is text Arabic? false');
    return false;
  }
}

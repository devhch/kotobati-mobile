/*
* Created By Mirai Devs.
* On 6/23/2023.
*/
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/utils/app_config.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_cached_image_network_widget.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:share_plus/share_plus.dart';

import 'text_bottom_sheet.dart';

class TextWidget extends StatefulWidget {
  const TextWidget({
    super.key,
    required this.book,
    required this.title,
    required this.page,
    this.text,
    this.image,
    this.cover,
    this.useCover = true,
  });

  final Book book;
  final String title;
  final int page;
  final String? text;
  final String? image;
  final String? cover;
  final bool useCover;

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  late File? imageFile;

  @override
  void initState() {
    super.initState();

    if (widget.image != null) {
      imageFile = File(widget.image!);
      if (!imageFile!.existsSync()) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    miraiPrint('TextWidget image ${widget.image}');
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: SizedBox(
        height: 268 + 45,
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 45,
              child: MiraiElevatedButtonWidget(
                height: 268,
                onTap: () {
                  Get.toNamed(
                    Routes.pdfReader,
                    arguments: <String, dynamic>{
                      "book": widget.book,
                      "page": widget.page,
                    },
                  );

                  Future<void>.delayed(
                    const Duration(milliseconds: 100),
                    () {
                      TextBottomSheet.showTextBottomSheet(text: widget.text, image: widget.image);
                    },
                  );
                },
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 32,
                  bottom: 16,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                side: const BorderSide(color: AppTheme.keyAppGrayColorDark, width: 2),
                backgroundColor: AppTheme.keyAppBlackColor,
                child: Column(
                  children: <Widget>[
                    if (widget.text != null)
                      Expanded(
                        child: Text(
                          widget.text!,
                          style: context.textTheme.bodyLarge!.copyWith(
                            height: 1.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (imageFile != null)
                      Expanded(
                        child: Image.file(
                          imageFile!,
                          width: double.infinity,
                          // height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    // TODO Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: InkWell(
                    //     onTap: () async {
                    //       if (imageFile != null) {
                    //         //  TODO final Uint8List convertFileToUint8 = await convertFileToUint8List();
                    //
                    //         //  final File file = File(image!);
                    //         //  Uint8List fileBytes = imageFile!.readAsBytesSync();
                    //         //  XFile xFile = XFile(imageFile!.path);
                    //         // XFile? xFile = convertFileToXFile(file);
                    //
                    //         // if (xFile == null) return;
                    //
                    //         // XFile xFile = XFile.fromData(
                    //         //   fileBytes.buffer
                    //         //       .asUint8List(fileBytes.offsetInBytes, fileBytes.lengthInBytes),
                    //         //   name: 'quote.jpg',
                    //         //   mimeType: 'image/jpeg',
                    //         // );
                    //
                    //         final String text =
                    //             'إقتباس من ${widget
                    //             .title} تطبيق كتوباتي ، \nلتحميل التطبيق: ${AppConfig
                    //             .playStoreURL}  ';
                    //
                    //         /// Share File
                    //         // await shareFile(
                    //         //   xFile,
                    //         //   text:
                    //         //   text,
                    //         //   context: context,
                    //         // );
                    //
                    //         // Uint8List imageFileBytes = await fileToUint8List(imageFile!);
                    //
                    //         /// New Share
                    //         // FileChannel.shareFile(
                    //         //     fileBytes: imageFileBytes, title: text, fileName: 'quote'
                    //         //   //  "File Subject",
                    //         // );
                    //
                    //         FileChannel.shareFile(
                    //           imageFile!.path,
                    //           text,
                    //           "File Subject",
                    //         );
                    //       }
                    //     },
                    //     child: SvgPicture.asset(
                    //       AppIconsKeys.shareCircle,
                    //       width: 32,
                    //       height: 32,
                    //       fit: BoxFit.fill,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            if (widget.useCover && widget.cover != null)
              Positioned(
                bottom: 0,
                left: context.width / 2 - 40,
                child: Container(
                  color: AppTheme.keyAppBlackColor,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: MiraiCachedImageNetworkWidget(
                    width: 80,
                    height: 118,
                    imageUrl: '${widget.cover}',
                    title: widget.title,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

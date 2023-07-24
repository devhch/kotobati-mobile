/*
* Created By Mirai Devs.
* On 6/23/2023.
*/

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/pdf_reader/views/components/planing_bottom_sheet.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/delete_one_book_widget.dart';
import 'package:kotobati/app/widgets/mirai_cached_image_network_widget.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    miraiPrint('<=======================>');
    miraiPrint('\nBook ${book.toString()}');
    miraiPrint('<=======================>');
    return MiraiElevatedButtonWidget(
      backgroundColor: Colors.transparent,
      onTap: () {
        Get.toNamed(
          Routes.bookDetails,
          arguments: <String, dynamic>{"book": book},
        );
      },
      side: const BorderSide(
        color: AppTheme.keyAppGrayColorDark,
      ),
      margin: const EdgeInsets.only(bottom: 32),
      height: 165,
      padding: EdgeInsets.zero,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 165,
            width: 96,
            decoration: const BoxDecoration(),
            child: book.image != null && book.image!.contains(".svg")
                ? SvgPicture.network(
                    book.image!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    // width: MiraiSize.iconSize24,
                    // height: MiraiSize.iconSize24,
                  )
                : book.image != null && book.image is String
                    ? MiraiCachedImageNetworkWidget(
                        imageUrl: book.image!,
                        fit: BoxFit.fill,
                        width: 96,
                        //  width: double.infinity,
                        //    width: MiraiSize.iconSize24,
                        title: book.title!,
                        // height: MiraiSize.iconSize24,
                        // color: AppTheme.keyAppBlackColor,
                      )
                    : book.image != null && book.image is Uint8List
                        ? Container(
                            color: Colors.white,
                            child: Image.memory(
                              book.image,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox.shrink(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  if (book.title != null)
                    Text(
                      book.title!,
                      style: context.textTheme.headlineMedium!.copyWith(
                        fontSize: 22,
                      ),
                      maxLines: 1,
                    ),
                  const SizedBox(height: 15),
                  if (book.author != null)
                    Text(
                      book.author!,
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 22),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          child: Row(
                            //  mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  book.planingBook = listPlaningBooks[0];
                                  await HiveDataStore().updateBook(book: book);
                                },
                                child: SvgPicture.asset(
                                  AppIconsKeys.reading,
                                  width: 16,
                                  colorFilter: book.planingBook != null && book.planingBook!.id == 1
                                      ? const ColorFilter.mode(
                                          AppTheme.keyAppColor,
                                          BlendMode.srcIn,
                                        )
                                      : null,
                                ),
                              ),
                              const ContainerDivider(),
                              InkWell(
                                onTap: () async {
                                  book.planingBook = listPlaningBooks[1];
                                  await HiveDataStore().updateBook(book: book);
                                },
                                child: SvgPicture.asset(
                                  AppIconsKeys.readLater,
                                  width: 16,
                                  // color: AppTheme.keyAppColor,
                                  colorFilter: book.planingBook != null && book.planingBook!.id == 2
                                      ? const ColorFilter.mode(
                                          AppTheme.keyAppColor,
                                          BlendMode.srcIn,
                                        )
                                      : null,
                                ),
                              ),
                              const ContainerDivider(),
                              InkWell(
                                onTap: () async {
                                  book.planingBook = listPlaningBooks[2];
                                  await HiveDataStore().updateBook(book: book);
                                },
                                child: SvgPicture.asset(
                                  AppIconsKeys.readed,
                                  width: 16,
                                  colorFilter: book.planingBook != null && book.planingBook!.id == 3
                                      ? const ColorFilter.mode(
                                          AppTheme.keyAppColor,
                                          BlendMode.srcIn,
                                        )
                                      : null,
                                ),
                              ),
                              const ContainerDivider(),
                              InkWell(
                                onTap: () {
                                  PlaningBottomSheet.show(book: book);
                                },
                                child: SvgPicture.asset(
                                  AppIconsKeys.addCollection,
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                              const ContainerDivider(),
                              InkWell(
                                onTap: () {
                                  /// Share File
                                  shareFile(book.path!, subject: book.title!);
                                },
                                child: SvgPicture.asset(
                                  AppIconsKeys.share,
                                  width: 16,
                                ),
                              ),
                              const ContainerDivider(margin: EdgeInsetsDirectional.only(start: 12)),
                              DeleteOneBookWidget(book: book),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerDivider extends StatelessWidget {
  const ContainerDivider({
    Key? key,
    this.height = 16,
    this.width = 2,
    this.margin,
  }) : super(key: key);

  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 12),
      height: height,
      width: width,
      color: AppTheme.keyAppGrayColorDark,
    );
  }
}

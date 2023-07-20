/*
* Created By Mirai Devs.
* On 14/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/planing/views/components/add_dialog.dart';
import 'package:kotobati/app/modules/planing/views/planing_view.dart';
import 'package:kotobati/app/widgets/card_text_icon_widget.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

class PlaningBottomSheet {
  static void show({
    required Book book,
  }) {
    Get.bottomSheet(
      _PlaningBottomSheetBody(book: book),
      isScrollControlled: true,
    );
  }
}

class _PlaningBottomSheetBody extends StatelessWidget {
  const _PlaningBottomSheetBody({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 16,
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 2),
              decoration: const BoxDecoration(
                color: AppTheme.keyAppWhiteGrayColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppIconsKeys.arrowBottom,
                color: AppTheme.keyAppBlackColor,
                width: 6,
                height: 10,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Container(
              //    height: 400,
              padding: EdgeInsets.symmetric(
                //vertical: MiraiSize.space16,
                horizontal: MiraiSize.space32,
              ),
              decoration: BoxDecoration(
                color: AppTheme.keyAppLightGrayColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MiraiSize.radius20),
                  topRight: Radius.circular(MiraiSize.radius20),
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40),
                  Expanded(
                    child: ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: listPlaningBooks.length,
                      itemBuilder: (_, int index) {
                        final PlaningBooksModel planingBook = listPlaningBooks[index];
                        return CardTextIconWidget(
                          planingBooksModel: planingBook,
                          margin: const EdgeInsets.only(bottom: 40),
                          onTap: () async {
                            book.planingBook = planingBook;
                            final bool isBookAdded =
                                await HiveDataStore().updateBook(book: book);

                            if (isBookAdded) {
                              AppMiraiDialog.snackBar(
                                backgroundColor: Colors.green,
                                title: 'عظيم',
                                message:
                                    'تمت إضافة ${book.title?.replaceAll('pdf', '')} إلى ${planingBook.name}',
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),

                  //   const SizedBox(height: 5),
                  IconButton(
                    iconSize: 46,
                    onPressed: () {
                      AddDialog.showAddDialog();
                    },
                    icon: SvgPicture.asset(
                      AppIconsKeys.addCollection,
                      width: 55,
                      height: 55,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 20),
                  //   const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

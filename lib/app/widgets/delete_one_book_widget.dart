/*
* Created By Mirai Devs.
* On 18/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/widgets/mirai_verifying_dialog.dart';

class DeleteOneBookWidget extends StatelessWidget {
  const DeleteOneBookWidget({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      iconSize: 5,
      splashRadius: 5,
      color: const Color(0xff464444),
      position: PopupMenuPosition.under,
      icon: SvgPicture.asset(
        AppIconsKeys.settingPoint,
        width: 5,
        height: 16,
      ),
      onSelected: (int value) {
        if (value == 0) {
          MiraiVerifyingDialog.showDialog(
            yes: () async {
              deleteFile(book.path!);
              final bool isDeleted = await HiveDataStore().deleteBook(book: book);
              // if (isDeleted) {
              Get.back();
              Get.back();
              // } else {
              //   AppMiraiDialog.snackBarError(
              //     title: 'OPS!',
              //     message: 'نعتذر ولكن يبدو أن الكتاب لا يمكن حذفه.',
              //   );
              // }
            },
            yesText: 'حذف',
            no: () {
              Get.back();
            },
            noText: 'لا',
            title: 'هل ترغب في متابعة حذف هذا الكتاب؟',
          );
        }
      },
      itemBuilder: (_) {
        return <PopupMenuItem<int>>[
          PopupMenuItem<int>(
            value: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'حذف',
              style: context.textTheme.labelMedium!.copyWith(

                fontWeight: FontWeight.bold,
                color: AppTheme.keyAppColor,
              ),
            ),
          ),
        ];
      },
    );
  }
}

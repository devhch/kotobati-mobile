/*
* Created By Mirai Devs.
* On 18/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/pdf_reader/controllers/pdf_reader_controller.dart';
import 'package:kotobati/app/modules/pdf_reader/views/components/planing_bottom_sheet.dart';
import 'package:kotobati/app/widgets/mirai_verifying_dialog.dart';

class OptionsMenuWidget extends StatelessWidget {
  const OptionsMenuWidget({
    super.key,
    required GlobalKey<State<StatefulWidget>> optionsMenuKey,
    required this.controller,
  }) : _optionsMenuKey = optionsMenuKey;

  final GlobalKey<State<StatefulWidget>> _optionsMenuKey;
  final PdfReaderController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
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
              shareFile(controller.pdfFile!.path, subject:controller.book.value.title!);
              break;

            case 1:

              /// Delete
              MiraiVerifyingDialog.showDialog(
                yes: () async {
                  deleteFile(controller.book.value.path!);
                  final bool isDeleted =
                      await HiveDataStore().deleteBook(book: controller.book.value);
                  // if (isDeleted) {
                  Get.back();
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
              break;

            case 2:

              /// Add To
              if (controller.pdfFile != null) {
                // Get.toNamed(
                //   Routes.planing,
                //   arguments: controller.pdfFile,
                // );
                PlaningBottomSheet.show(book: controller.book.value);
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
    );
  }
}

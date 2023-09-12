import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/modules/planing/views/components/add_dialog.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/card_text_icon_widget.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';

import '../controllers/planing_controller.dart';

import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';

class PlaningView extends GetView<PlaningController> {
  const PlaningView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          Row(
            children: <Widget>[
              const Spacer(),
              MiraiElevatedButtonWidget(
                side: const BorderSide(width: 1, color: AppTheme.keyAppGrayColor),
                borderRadius: BorderRadius.circular(10),
                backgroundColor: AppTheme.keyAppBlackColor,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                overlayColor: AppTheme.keyAppGrayColor.withOpacity(.2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      AppIconsKeys.addCollection,
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'آضف ملف',
                      style: context.textTheme.headlineMedium!.copyWith(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  AddDialog.showAddDialog();
                },
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: listPlaningBooks.length,
                itemBuilder: (_, int index) {
                  final PlaningBooksModel planingBooks = listPlaningBooks[index];
                  return CardTextIconWidget(
                    planingBooksModel: planingBooks,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    onTap: () {
                      if (controller.pdfFile == null) {
                        Get.toNamed(
                          Routes.planingDetails,
                          arguments: <String, dynamic>{
                            "planingBooksModel": planingBooks,
                          },
                        );
                      } else {}
                    },
                  );
                },
              );
            },
          ),
          //     const SizedBox(height: 50),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

/*
* Created By Mirai Devs.
* On 12/9/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/search/controllers/search_controller.dart';
import 'package:kotobati/app/widgets/mirai_text_field_widget.dart';

class SearchTextFieldWidget extends StatelessWidget {
  const SearchTextFieldWidget({
    super.key,
    required this.controller,
    required this.textEditingController,
  });

  final SearchPDFController controller;
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
            onChanged: controller.search,
            onFieldSubmitted: (String query) async {
              if (query.isNotEmpty) {
                // controller.search(query);
                await HiveDataStore().saveSearchHistory(query: query);
              }
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

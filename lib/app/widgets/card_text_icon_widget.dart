/*
* Created By Mirai Devs.
* On 6/22/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

import '../modules/planing/controllers/planing_controller.dart';

class CardTextIconWidget extends StatelessWidget {
  const CardTextIconWidget({
    Key? key,
    required this.planingBooksModel,
    required this.planingController,
  }) : super(key: key);

  final PlaningBooksModel planingBooksModel;
  final PlaningController planingController;

  @override
  Widget build(BuildContext context) {
    return MiraiElevatedButtonWidget(
      onTap: () {
        if (planingController.pdfFile == null) {
          Get.toNamed(
            Routes.planingDetails,
            arguments: <String, dynamic>{
              "planingBooksModel": planingBooksModel,
            },
          );
        } else {}
      },
      backgroundColor: AppTheme.keyAppBlackColor,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(
        color: AppTheme.keyAppGrayColorDark,
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            height: 78,
            width: 66,
            decoration: const BoxDecoration(
              color: AppTheme.keyAppColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: SvgPicture.asset(
              planingBooksModel.icon,
              // fit: BoxFit.fill,
              width: MiraiSize.iconSize24,
              height: MiraiSize.iconSize24,
              color: AppTheme.keyAppBlackColor,
            ),
          ),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            child: Text(
              planingBooksModel.name,
              style: context.textTheme.headlineMedium!.copyWith(
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
* Created By Mirai Devs.
* On 6/23/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({Key? key, required this.bookModel}) : super(key: key);
  final BookModel bookModel;

  @override
  Widget build(BuildContext context) {
    return MiraiElevatedButtonWidget(
      backgroundColor: Colors.transparent,
      onTap: () {
        Get.toNamed(
          Routes.bookDetails,
          arguments: <String, dynamic>{"book": bookModel},
        );
      },
      side: const BorderSide(
        color: AppTheme.keyAppGrayColorDark,
      ),
      margin: const EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.zero,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            height: 140,
            width: 96,
            decoration: const BoxDecoration(
              color: AppTheme.keyAppColor,
            ),
            child: SvgPicture.asset(
              bookModel.image!,
              // fit: BoxFit.fill,
              width: MiraiSize.iconSize24,
              height: MiraiSize.iconSize24,
              color: AppTheme.keyAppBlackColor,
            ),
          ),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  bookModel.title!,
                  style: context.textTheme.headlineMedium!.copyWith(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  bookModel.author!,
                  style: context.textTheme.bodyMedium!.copyWith(),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIconsKeys.reading,
                        width: 16,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIconsKeys.readLater,
                        width: 16,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIconsKeys.readed,
                        width: 16,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIconsKeys.addCollection,
                        width: 16,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIconsKeys.share,
                        width: 16,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIconsKeys.settingPoint,
                        width: 6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerDivider extends StatelessWidget {
  const ContainerDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 16,
      width: 2,
      color: AppTheme.keyAppGrayColorDark,
    );
  }
}

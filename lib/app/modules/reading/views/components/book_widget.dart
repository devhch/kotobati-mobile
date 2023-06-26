/*
* Created By Mirai Devs.
* On 6/23/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_cached_image_network_widget.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    miraiPrint('\nBook ${book.toString()}');
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
      height: 140,
      padding: EdgeInsets.zero,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
      ),
      child: Row(
        children: <Widget>[
          Container(
            // padding: const EdgeInsets.symmetric(
            //   horizontal: 16,
            //   vertical: 10,
            // ),
            height: 140,
            width: 96,
            decoration: const BoxDecoration(
             // color: AppTheme.keyAppColor,
            ),
            child: book.image != null && book.image!.contains(".svg")
                ? SvgPicture.network(
                    book.image!,
                     fit: BoxFit.contain,
                    width: double.infinity,
                    // width: MiraiSize.iconSize24,
                    // height: MiraiSize.iconSize24,
                  )
                : MiraiCachedImageNetworkWidget(
                    imageUrl: book.image!,
                    fit: BoxFit.fill,
                    width: 96,
                    //  width: double.infinity,
                    //    width: MiraiSize.iconSize24,
                    title: book.title!,
                    // height: MiraiSize.iconSize24,
                    // color: AppTheme.keyAppBlackColor,
                  ),
          ),
          // const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Text(
                    book.title!,
                    style: context.textTheme.headlineMedium!.copyWith(
                      fontSize: 22,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    book.author!,
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontSize: 12,
                      fontFamily: AppTheme.fontBold,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Row(
                            //  mainAxisSize: MainAxisSize.min,
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
                                  width: 5,
                                ),
                              ),
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
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: height,
      width: width,
      color: AppTheme.keyAppGrayColorDark,
    );
  }
}

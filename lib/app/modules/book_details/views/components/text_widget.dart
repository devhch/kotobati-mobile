/*
* Created By Mirai Devs.
* On 6/23/2023.
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/utils/app_config.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/widgets/mirai_cached_image_network_widget.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';

import 'text_bottom_sheet.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.title,
    this.text,
    this.image,
    this.cover,
    this.useCover = true,
  });

  final String title;
  final String? text;
  final String? image;
  final String? cover;
  final bool useCover;

  @override
  Widget build(BuildContext context) {
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
                onTap: () => TextBottomSheet.showTextBottomSheet(text: text, image: image),
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
                    if (text != null)
                      Expanded(
                        child: Text(
                          text!,
                          style: context.textTheme.bodyLarge!.copyWith(
                            height: 1.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (image != null)
                      Expanded(
                        child: Image.file(
                          File(image!),
                          width: double.infinity,
                          // height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          if (image != null) {
                            /// Share File
                            shareFile(image!,
                                text:
                                    'إقتباس من $title تطبيق كتوباتي ، \nلتحميل التطبيق: ${AppConfig.playStoreURL}  ');
                          }
                        },
                        child: SvgPicture.asset(
                          AppIconsKeys.shareCircle,
                          width: 32,
                          height: 32,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (useCover && cover != null)
              Positioned(
                bottom: 0,
                left: context.width / 2 - 40,
                child: Container(
                  color: AppTheme.keyAppBlackColor,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: MiraiCachedImageNetworkWidget(
                    width: 80,
                    height: 118,
                    imageUrl: '$cover',
                    title: title,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

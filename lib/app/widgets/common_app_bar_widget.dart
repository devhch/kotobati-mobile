/*
* Created By Mirai Devs.
* On 6/22/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/routes/app_pages.dart';

class CommonAppBarWidget extends StatelessWidget {
  const CommonAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: context.width,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: SvgPicture.asset(
              AppIconsKeys.appBar,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.search);
                  },
                  icon: SvgPicture.asset(AppIconsKeys.search),
                ),
                SvgPicture.asset(AppIconsKeys.ktobatiIcon),
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.settings);
                  },
                  icon: SvgPicture.asset(AppIconsKeys.setting),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

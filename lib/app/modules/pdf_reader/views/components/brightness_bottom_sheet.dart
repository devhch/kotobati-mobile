/*
* Created By Mirai Devs.
* On 20/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

class BrightnessBottomSheet {
  static void show({
    required ValueNotifier<double> brightness,
    required ValueChanged<double> onChanged,
  }) {
    Get.bottomSheet(
      _BrightnessBottomSheetBody(
        brightness: brightness,
        onChanged: onChanged,
      ),
      isScrollControlled: true,
    );
  }
}

class _BrightnessBottomSheetBody extends StatelessWidget {
  const _BrightnessBottomSheetBody({
    super.key,
    required this.brightness,
    required this.onChanged,
  });

  final ValueNotifier<double> brightness;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
              alignment: Alignment.center,
              child: ValueListenableBuilder<double>(
                valueListenable: brightness,
                builder: (_, double bright, __) {
                  return Slider.adaptive(
                    value: bright,
                    min: 0.0,
                    max: 1.0,
                    // label: '${bright + 1}',
                    inactiveColor: AppTheme.keySliderInactiveColor,
                    onChanged: onChanged,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

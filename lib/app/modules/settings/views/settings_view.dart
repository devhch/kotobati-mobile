import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';

import '../controllers/settings_controller.dart';
import 'components/circle_thumb_shape.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      backButton: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                width: context.width,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xff242424),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'قلب الصفحة',
                      style: context.textTheme.bodyLarge!.copyWith(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'عمودي',
                          style: context.textTheme.labelMedium!.copyWith(
                            color: AppTheme.keyAppWhiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(AppIconsKeys.arrowBottom),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: context.width,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xff242424),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'وضع القراءة',
                      style: context.textTheme.bodyLarge!.copyWith(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'ليلي',
                          style: context.textTheme.labelMedium!.copyWith(
                            color: AppTheme.keyAppWhiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(AppIconsKeys.arrowBottom),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: context.width,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xff242424),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          'هامش الصفحة : ',
                          style: context.textTheme.bodyLarge!.copyWith(),
                        ),
                        const SizedBox(width: 15),
                        Obx(() {
                          double distance = double.parse(
                              controller.zoneDistance.value.toStringAsFixed(0));

                          return Text(
                            distance.toStringAsFixed(0),
                            style: context.textTheme.labelMedium!.copyWith(
                              color: AppTheme.keyAppWhiteColor,
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6.0,
                        trackShape: const RoundedRectSliderTrackShape(),
                        activeTrackColor: AppTheme.keyAppColor,
                        inactiveTrackColor: Colors.white,
                        thumbShape: const CircleThumbShape(thumbRadius: 8),
                        thumbColor: AppTheme.keyAppColorDark,
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 0.0,
                        ),
                        tickMarkShape: const RoundSliderTickMarkShape(),
                      ),
                      child: Obx(() {
                        return Slider(
                          min: 0.0,
                          max: 50.0,
                          value: controller.zoneDistance.value,
                          onChanged: (double value) {
                            controller.zoneDistance.value = value;
                          },
                          onChangeEnd: (double value) {
                            // controller.updateDistance(value);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(AppIconsKeys.happyFace),
                  Text(
                    '  قيمنا',
                    style: context.textTheme.labelMedium!.copyWith(
                      color: AppTheme.keyAppWhiteColor,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'كيف كان التطبيق',
                style: context.textTheme.bodyLarge!.copyWith(),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < 5; i++)
                    const FaIcon(FontAwesomeIcons.star),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                'تابعنا على',
                style: context.textTheme.labelMedium!.copyWith(
                  color: AppTheme.keyAppWhiteColor,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(AppIconsKeys.instagram),
                  const SizedBox(width: 35),
                  SvgPicture.asset(AppIconsKeys.facebook),
                  const SizedBox(width: 35),
                  SvgPicture.asset(AppIconsKeys.whatsapp),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

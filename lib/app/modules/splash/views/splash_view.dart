import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/widgets/card_text_icon_widget.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              'SplashView is working',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 25),
          MiraiElevatedButtonWidget(
            onTap: () {},
            child: Text(
              "Button",
              style: context.textTheme.bodySmall!.copyWith(
                color: AppTheme.keyAppGrayColor,
              ),
            ),
          ),
          const SizedBox(height: 25),
          MiraiElevatedButtonWidget(
            onTap: () {},
            rounded: true,
            child: Text(
              "Button",
              style: context.textTheme.bodySmall!.copyWith(
                color: AppTheme.keyAppBlackColor,
              ),
            ),
          ),
          const SizedBox(height: 25),
          const CardTextIconWidget(
            text: "كتب  أقرأها",
            icon: AppIconsKeys.readLater,
          ),
        ],
      ),
    );
  }
}

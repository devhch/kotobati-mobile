import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';

import '../../../data/persistence/hive_data_store.dart';
import '../controllers/intro_controller.dart';

class IntroView extends GetView<IntroController> {
  const IntroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.keyAppBlackColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'مرحبا بك',
                  style: context.textTheme.displayLarge!.copyWith(
                    fontSize: 34,
                  ),
                ),
                const SizedBox(height: 55),
                Text(
                  """مع نسخة كوتوباتي للقارئ يمكنك تنظيم قراءتك وتحسين مستواك الفكري و الثقافي.""",
                  style: context.textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 98),
                MiraiElevatedButtonWidget(
                  onTap: () async {
                    HiveDataStore hiveDataStore = HiveDataStore();
                    await hiveDataStore.saveIntroSeenState(isSeen: true);
                    Get.offNamed(Routes.navigation);
                  },
                  rounded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  overlayColor: Colors.white.withOpacity(.2),
                  child: Text(
                    "متابعة",
                    style: context.textTheme.displayLarge!.copyWith(
                      color: AppTheme.keyAppBlackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

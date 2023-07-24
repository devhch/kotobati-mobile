import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';

import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late List<String> imagePaths;

  @override
  void initState() {
    super.initState();
    // Image paths that you want to precache
    imagePaths = <String>[
      AppIconsKeys.addBooks,
      AppIconsKeys.web,
      AppIconsKeys.webSelected,
      AppIconsKeys.books,
      AppIconsKeys.booksSelected,
      AppIconsKeys.recent,
      AppIconsKeys.recentSelected,
      AppIconsKeys.file,
      AppIconsKeys.fileSelected,
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); // Precache the images here
    precacheImages(imagePaths, context);
  }

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
                  onTap: () {
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

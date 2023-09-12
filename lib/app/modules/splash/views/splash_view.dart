import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  /// Find This Controller
  final SplashController controller = Get.find<SplashController>();

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
    debugPrint(controller.state);
    return Scaffold(
      backgroundColor: AppTheme.keyAppBlackColor,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              color: AppTheme.keyAppColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              AppIconsKeys.kotobatiWhiteIcon,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

/*
* Created By Mirai Devs.
* On 10/20/2021.
*/
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/widgets/switch_widget_state.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

import 'app_enums.dart';
import 'app_language_keys.dart';
import 'app_theme.dart';

class AppMiraiDialog {
  static void snackBar({
    required String title,
    required String message,
    int duration = 2,
    Color textColor = Colors.white,
    Color backgroundColor = AppTheme.keyAppColor,
  }) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: duration),
      colorText: textColor,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(16),
      instantInit: true,
    );
  }

  static void snackBarError({
    String? title,
    String? message,
    int duration = 2,
    Color textColor = Colors.white,
    Color backgroundColor = Colors.red,
  }) {
    snackBar(
      title: title ?? AppLanguagesKeys.keyAttention.tr,
      message: message ?? AppLanguagesKeys.keySomethingWrong.tr,
      duration: duration,
      textColor: textColor,
      backgroundColor: backgroundColor,
    );
  }

  static void customDialogBar({
    String title = 'loading...',
  }) {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            height: 200,
            width: MiraiSize.screenWidth - 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  blurRadius: 5.0,
                  color: Colors.black26,
                  offset: Offset(0.0, 3.0),
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 5),
                SpinKitFadingFour(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.grey[200] : Colors.grey[600],
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: Get.theme.textTheme.headline1!.copyWith(
                    color: AppTheme.keyAppColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void miraiDialogBar({
    String title = 'Loading...',
  }) {
    Get.dialog(
      Material(
        color: Colors.transparent,
        child: MiraiDialogBodyWidget(title: title),
      ),
      barrierDismissible: false,
    );
  }
}

class MiraiDialogBodyWidget extends StatelessWidget {
  const MiraiDialogBodyWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        //   height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppTheme.keyAppBlackColor,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              blurRadius: 5.0,
              color: Colors.black26,
              offset: Offset(0.0, 3.0),
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MiraiSize.space40),
            SwitchLoginState(
              response: MiraiResponseEnum.loading,
              colorLoading: AppTheme.keyAppColor,
              size: MiraiSize.iconSize40,
              child: const SizedBox.shrink(),
            ),
            SizedBox(height: MiraiSize.space20),
            // Text(
            //   title,
            //   style: Get.theme.textTheme.bodyLarge!.copyWith(
            //     color: AppTheme.keyAppColor,
            //   ),
            // ),
            DefaultTextStyle(
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.bodyLarge!.copyWith(
                color: AppTheme.keyAppColor,
                fontWeight: FontWeight.w600,
              ),
              child: AnimatedTextKit(
                totalRepeatCount: 20,
                pause: const Duration(microseconds: 200),
                animatedTexts: <TypewriterAnimatedText>[
                  TypewriterAnimatedText(
                    title,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: MiraiSize.space40),
          ],
        ),
      ),
    );
  }
}

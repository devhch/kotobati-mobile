/*
* Created By Mirai Devs.
* On 06/22/2023.
*/
import 'package:flutter/material.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

import 'app_theme.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme textTheme() {
    return TextTheme(
      labelMedium: TextStyle(
        color: AppTheme.keyAppGrayColor,
        fontSize: MiraiSize.textSize14,
        fontFamily: AppTheme.fontRegular,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: MiraiSize.textSize20,
        fontFamily: AppTheme.fontBold,
      ),
      displayLarge: TextStyle(
        color: AppTheme.keyAppGrayColor,
        // fontWeight: FontWeight.bold,
        fontFamily: AppTheme.fontBold,
        fontSize: MiraiSize.textSize18,
      ),
      displayMedium: TextStyle(
        color: AppTheme.keyAppGrayColor,
        // fontWeight: FontWeight.bold,
        fontFamily: AppTheme.fontBold,
        fontSize: MiraiSize.textSize16,
      ),
      displaySmall: TextStyle(
        color: AppTheme.keyAppGrayColor,
        //fontWeight: FontWeight.bold,
        fontFamily: AppTheme.fontRegular,
        fontSize: MiraiSize.textSize14,
      ),
      bodyLarge: TextStyle(
        color: AppTheme.keyAppGrayColor,
        fontSize: MiraiSize.textSize14,
        fontWeight: FontWeight.w400,
        fontFamily: AppTheme.fontRegular,
      ),
      bodyMedium: TextStyle(
        color: AppTheme.keyAppGrayColor,
        fontSize: MiraiSize.textSize12,
        fontWeight: FontWeight.w400,
        fontFamily: AppTheme.fontRegular,
      ),
      titleMedium: TextStyle(
        color: AppTheme.keyAppGrayColor,
        fontWeight: FontWeight.w400,
        fontSize: MiraiSize.textSize10,
        fontFamily: AppTheme.fontRegular,
      ),
      titleSmall: TextStyle(
        color: AppTheme.keyAppGrayColor,
        fontWeight: FontWeight.w400,
        fontSize: MiraiSize.textSize8,
        fontFamily: AppTheme.fontRegular,
      ),
    );
  }
}

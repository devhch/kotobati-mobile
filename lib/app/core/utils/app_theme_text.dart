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
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: MiraiSize.textSize20,
      ),
      displayLarge: TextStyle(
        color: AppTheme.keyAppGrayColor,
        // fontWeight: FontWeight.bold,
        fontFamily: 'UniviaPro-Bold',
        fontSize: MiraiSize.textSize18,
      ),
      displayMedium: TextStyle(
        color: AppTheme.keyAppGrayColor,
        // fontWeight: FontWeight.bold,
        fontFamily: 'UniviaPro-Bold',
        fontSize: MiraiSize.textSize16,
      ),
      displaySmall: TextStyle(
        color: AppTheme.keyAppGrayColor,
        //fontWeight: FontWeight.bold,
        fontFamily: 'UniviaPro-Bold',
        fontSize: MiraiSize.textSize14,
      ),
      bodyLarge: TextStyle(
        color: AppTheme.keyAppGrayColor,
        fontSize: MiraiSize.textSize14,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppTheme.keyAppGrayColor,
        fontSize: MiraiSize.textSize12,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        color: AppTheme.keyAppGrayColor,
        fontWeight: FontWeight.w400,
        fontSize: MiraiSize.textSize10,
      ),
      titleSmall: TextStyle(
        color: AppTheme.keyAppGrayColor,
        fontWeight: FontWeight.w400,
        fontSize: MiraiSize.textSize8,
      ),
    );
  }
}

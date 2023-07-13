/*
* Created By Mirai Devs.
* On 06/22/2023.
*/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

import 'app_theme.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme textTheme() {
    return TextTheme(
      labelMedium: GoogleFonts.tajawal(
        color: AppTheme.keyAppGrayColor,
        fontSize: MiraiSize.textSize14,
      ),

      // labelMedium: GoogleFonts.tajawal(
      //   color: AppTheme.keyAppGrayColor,
      //   fontSize: MiraiSize.textSize14,
      //   fontFamily: AppTheme.fontRegular,
      // ),
      labelLarge: GoogleFonts.tajawal(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: MiraiSize.textSize20,
      ),
      displayLarge: GoogleFonts.tajawal(
        color: AppTheme.keyAppGrayColor,
        // fontWeight: FontWeight.bold,

        fontSize: MiraiSize.textSize18,
      ),
      displayMedium: GoogleFonts.tajawal(
        color: AppTheme.keyAppGrayColor,
        // fontWeight: FontWeight.bold,

        fontSize: MiraiSize.textSize16,
      ),
      displaySmall: GoogleFonts.tajawal(
        color: AppTheme.keyAppGrayColor,
        //fontWeight: FontWeight.bold,

        fontSize: MiraiSize.textSize14,
      ),
      bodyLarge: GoogleFonts.tajawal(
        color: AppTheme.keyAppGrayColor,
        fontSize: MiraiSize.textSize14,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.tajawal(
        color: AppTheme.keyAppGrayColor,
        fontSize: MiraiSize.textSize12,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: GoogleFonts.tajawal(
        color: AppTheme.keyAppGrayColor,
        fontWeight: FontWeight.w400,
        fontSize: MiraiSize.textSize10,
      ),
      titleSmall: GoogleFonts.tajawal(
        color: AppTheme.keyAppGrayColor,
        fontWeight: FontWeight.w400,
        fontSize: MiraiSize.textSize8,
      ),
    );
  }
}

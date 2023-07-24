/*
* Created By Mirai Devs.
* On 06/22/2023.
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme_text.dart';

abstract class AppTheme {
  static const Color keyAppColor = Color(0xFFF65656);
  static const Color keyAppColorDark = Color(0xFFD43A3A);
  static const Color keyAppBlackColor = Color(0xFF0C0B0B);
  static const Color keyAppBarColor = Color(0xFF242424);
  static const Color keyBlackGreyColor = Color(0xFF232323);
  static const Color keyHintGreyColor = Color(0xFF363434);
  static const Color keyAppGrayColor = Color(0xFFA1A1A1);
  static const Color keyAppLightGrayColor = Color(0xFF464444);
  static const Color keyAppGrayColorDark = Color(0xFF707070);
  static const Color keyMenuItemGrayColor = Color(0xFF585858);
  static const Color keyAppWhiteColor = Color(0xFFFFFFFF);
  static const Color keyAppWhiteGrayColor = Color(0xFFCFCFCF);
  static const Color keySliderInactiveColor = Color(0xFFD4D1D1);
  static const Color keyIconsGreyColor = Color(0xFFD4D2D2);

  final Color highlightColor = keyAppColor.withOpacity(0.8);

  static Duration shimmerDuration = const Duration(milliseconds: 1200);

  static Color highlightColorShimmer = Colors.grey[100]!;
  static Color baseColorShimmer = Colors.grey[300]!;

  /// ThemeData
  static ThemeData get themeData => ThemeData(
        // backgroundColor: keyAppColor,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
        colorScheme: const ColorScheme.dark(
          secondary: keyAppColor,
          primary: keyAppColorDark,
          background: keyAppBlackColor,
        ),
        fontFamily: GoogleFonts.tajawal().fontFamily,
        appBarTheme: const AppBarTheme(color: keyAppColor),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: keyAppColor,
        cardColor: keyAppBlackColor,
        highlightColor: keyAppColor.withOpacity(.2),
        splashColor: keyAppColor.withOpacity(.2),
        textTheme: AppTextTheme.textTheme(),
      );

  final OutlineInputBorder outlineInputBorderForTextField = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(
      color: keyAppGrayColorDark,
      width: 2,
    ),
  );

  static OutlineInputBorder miraiOutlineInputBorderForTextField({
    Color? color,
    double? borderRadius,
    double? borderWidth,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 28),
      borderSide: BorderSide(
        width: borderWidth ?? 2,
        color: color ?? keyAppGrayColorDark,
      ),
    );
  }

  static UnderlineInputBorder miraiUnderlineInputBorder({
    Color? color,
    double? borderRadius,
    double? borderWidth,
  }) {
    return UnderlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 28),
      borderSide: BorderSide(
        width: borderWidth ?? 2,
        color: color ?? keyAppGrayColorDark,
      ),
    );
  }
}

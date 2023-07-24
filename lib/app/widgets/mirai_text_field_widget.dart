/*
* Created By Mirai Devs.
* On 21/9/2022.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

class MiraiTextFieldWidget extends StatelessWidget {
  const MiraiTextFieldWidget({
    Key? key,
    required this.hint,
    this.controller,
    this.enabled = true,
    this.textFieldHeight,
    this.textFieldWidth,
    this.maxLines,
    this.borderRadius,
    this.borderWidth,
    this.labelColor = AppTheme.keyAppGrayColor,
    this.borderColor,
    this.fillColor,
    this.margin,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.underLine = false,
    this.contentPadding,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.style,
    this.hintStyle,
  }) : super(key: key);

  final String hint;
  final TextEditingController? controller;
  final bool enabled;
  final double? textFieldHeight;
  final double? textFieldWidth;
  final int? maxLines;
  final double? borderRadius;
  final double? borderWidth;
  final Color labelColor;
  final Color? borderColor;
  final Color? fillColor;
  final EdgeInsetsGeometry? margin;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool underLine;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextStyle? style;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: textFieldHeight,
      width: textFieldWidth,
      margin: margin,
      child: TextFormField(
        validator: validator,
        enabled: enabled,
        maxLines: maxLines,
        // autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        style: style ??
            Get.theme.textTheme.displayMedium?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.bold,
            ),
        cursorColor: AppTheme.keyAppColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? Colors.white,
          contentPadding: contentPadding ?? EdgeInsets.all(MiraiSize.space18),
          /*
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
              width: 1.0,
            ),
          ),*/
          border: underLine
              ? AppTheme.miraiUnderlineInputBorder(
                  color: borderColor,
                  borderRadius: borderRadius,
                  borderWidth: borderWidth,
                )
              : AppTheme.miraiOutlineInputBorderForTextField(
                  color: borderColor,
                  borderRadius: borderRadius,
                  borderWidth: borderWidth,
                ),
          focusedBorder: underLine
              ? AppTheme.miraiUnderlineInputBorder(
                  color: borderColor,
                  borderRadius: borderRadius,
                  borderWidth: borderWidth,
                )
              : AppTheme.miraiOutlineInputBorderForTextField(
                  color: AppTheme.keyAppColor,
                  borderRadius: borderRadius,
                  borderWidth: borderWidth,
                ),
          enabledBorder: underLine
              ? AppTheme.miraiUnderlineInputBorder(
                  color: borderColor,
                  borderRadius: borderRadius,
                  borderWidth: borderWidth,
                )
              : AppTheme.miraiOutlineInputBorderForTextField(
                  color: borderColor,
                  borderRadius: borderRadius,
                  borderWidth: borderWidth,
                ),
          hintStyle: hintStyle ??
              Get.theme.textTheme.bodyText1!.copyWith(
                color: AppTheme.keyAppGrayColorDark,
              ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hint,
        ),
        keyboardType: keyboardType ?? TextInputType.emailAddress,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
      ),
    );
  }
}

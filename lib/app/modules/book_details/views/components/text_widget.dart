/*
* Created By Mirai Devs.
* On 6/23/2023.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
        ),
        border: Border.all(
          color: AppTheme.keyAppGrayColorDark,
        ),
      ),
      child: Text(
        text,
        style: context.textTheme.bodyMedium!.copyWith(),
      ),
    );
  }
}

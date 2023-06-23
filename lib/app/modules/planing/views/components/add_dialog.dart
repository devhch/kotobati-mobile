/*
* Created By Mirai Devs.
* On 6/23/2023.
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:kotobati/app/widgets/mirai_text_field_widget.dart';

class AddDialog {
  static Future<void> showAddDialog() async {
    await Get.dialog(
      const AddDialogWidget(),
    );
  }
}

class AddDialogWidget extends StatelessWidget {
  const AddDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          width: context.width - 100,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: const Color(0xff343333),
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
            children: <Widget>[
              const SizedBox(height: 10),
              const MiraiTextFieldWidget(
                hint: "أدخل اسم الملف...",
                fillColor: Color(0xff464444),
                borderColor: Color(0xff464444),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MiraiElevatedButtonWidget(
                    onTap: () {},
                    rounded: true,
                    child: Text(
                      "إضافة",
                      style: context.textTheme.labelMedium!.copyWith(
                        color: AppTheme.keyAppBlackColor,
                      ),
                    ),
                  ),
                  MiraiElevatedButtonWidget(
                    onTap: () {
                      Get.back();
                    },
                    rounded: true,
                    backgroundColor: AppTheme.keyAppGrayColorDark,
                    child: Text(
                      "إلغاء",
                      style: context.textTheme.labelMedium!.copyWith(
                        color: AppTheme.keyAppWhiteColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

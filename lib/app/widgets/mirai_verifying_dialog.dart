/*
* Created By Mirai Devs.
* On 13/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/app_theme.dart';
import 'mirai_elevated_button_widget.dart';

class MiraiVerifyingDialog {
  static Future<void> showDialog({
    required String title,
    required VoidCallback yes,
    required String yesText,
    required VoidCallback no,
    required String noText,
  }) async {
    await Get.dialog(
      _MiraiVerifyingDialogBody(
        title: title,
        yes: yes,
        yesText: yesText,
        no: no,
        noText: noText,
      ),
    );
  }
}

class _MiraiVerifyingDialogBody extends StatelessWidget {
  const _MiraiVerifyingDialogBody({
    Key? key,
    required this.title,
    required this.yes,
    required this.yesText,
    required this.no,
    required this.noText,
  }) : super(key: key);

  final String title;
  final VoidCallback yes;
  final String yesText;
  final VoidCallback no;
  final String noText;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          width: context.width - 100,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              const SizedBox(height: 20),
              Text(
                title,
                style: context.textTheme.displayLarge!.copyWith(
                  color: Colors.white,

                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MiraiElevatedButtonWidget(
                    onTap: yes,
                    rounded: true,
                    child: Text(
                      yesText,
                      style: context.textTheme.labelMedium!.copyWith(
                        color: AppTheme.keyAppBlackColor,
                      ),
                    ),
                  ),
                  MiraiElevatedButtonWidget(
                    onTap: no,
                    rounded: true,
                    backgroundColor: AppTheme.keyAppGrayColorDark,
                    child: Text(
                      noText,
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

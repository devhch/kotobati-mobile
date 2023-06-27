/*
* Created By Mirai Devs.
* On 6/23/2023.
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:kotobati/app/widgets/mirai_text_field_widget.dart';

class AddDialog {
  static Future<void> showAddDialog() async {
    TextEditingController textController = TextEditingController();

    await Get.dialog(
      AddDialogWidget(textController: textController),
    );
  }
}

class AddDialogWidget extends StatelessWidget {
  const AddDialogWidget({
    Key? key,
    required this.textController,
  }) : super(key: key);

  final TextEditingController textController;

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
              MiraiTextFieldWidget(
                hint: "أدخل اسم الملف...",
                fillColor: const Color(0xff464444),
                borderColor: const Color(0xff464444),
                controller: textController,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MiraiElevatedButtonWidget(
                    onTap: () => addPlaning(),
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

  void addPlaning() {
    if (textController.text.isEmpty) {
      return AppMiraiDialog.snackBarError(message: "PLZ ENTER A TEXT");
    }

    bool isSameName = listPlaningBooks.any(
      (PlaningBooksModel book) => book.name == textController.text,
    );

    if (isSameName) {
      return AppMiraiDialog.snackBarError(message: "ALREADY IN LIST");
    } //
    else {
      FocusManager.instance.primaryFocus?.unfocus();

      listPlaningBooks.add(
        PlaningBooksModel(
          id: listPlaningBooks.length + 1,
          name: textController.text,
          icon: AppIconsKeys.bookIcon,
        ),
      );

      HiveDataStore().savePlaningBook(planingBooks: listPlaningBooks);
      Get.back();
    }
  }
}

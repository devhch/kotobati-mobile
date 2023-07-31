/*
* Created By Mirai Devs.
* On 18/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/note_model.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/pdf_reader/controllers/pdf_reader_controller.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:kotobati/app/widgets/mirai_text_field_widget.dart';

class AddNoteToBookDialog {
  static Future<void> show(
      {required ValueNotifier<Book?> book, required VoidCallback callback}) async {
    TextEditingController textController = TextEditingController();

    await Get.dialog(
      _AddNoteToBookBody(
        book: book,
        textController: textController,
        callback: callback,
      ),
    );
  }
}

class _AddNoteToBookBody extends StatelessWidget {
  const _AddNoteToBookBody({
    Key? key,
    required this.book,
    required this.textController,
    required this.callback,
  }) : super(key: key);

  final ValueNotifier<Book?> book;
  final VoidCallback callback;
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
                hint: "أدخل ملاحظاتك لكتاب ${book.value?.title?.replaceAll('كتاب', '')}",
                fillColor: const Color(0xff464444),
                borderColor: const Color(0xff464444),
                borderRadius: 16,
                controller: textController,
                maxLines: 10,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MiraiElevatedButtonWidget(
                    //  height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    onTap: () async {
                      if (textController.text.isNotEmpty) {
                        // while (Get.isDialogOpen!) {
                        //   Get.back();
                        // }

                        // checkNotes(book.value.notes!);
                        final Note note = Note.create(content: textController.text);
                        book.value?.notes?.add(note);
                        book.notifyListeners();

                        callback.call();

                        final bool isBookAdded =
                            await HiveDataStore().updateBook(book: book.value!);

                        if (isBookAdded) {
                          AppMiraiDialog.snackBar(
                            backgroundColor: Colors.green,
                            title: 'عظيم',
                            message:
                                'تمت إضافة ملاحظة إلى ${book.value?.title?.replaceAll('pdf', '')} ',
                          );
                        }

                        textController.clear();

                        Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                      } else {
                        AppMiraiDialog.snackBarError(
                          title: 'Ops',
                          message: 'PLease enter text',
                        );
                      }
                    },
                    rounded: true,
                    overlayColor: Colors.white.withOpacity(.2),
                    child: Text(
                      "إضافة",
                      style: context.textTheme.labelMedium!.copyWith(
                        color: AppTheme.keyAppBlackColor,
                      ),
                    ),
                  ),
                  MiraiElevatedButtonWidget(
                    // height: 36,
                    onTap: () {
                      // Get.back();

                      Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                    },
                    rounded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    overlayColor: Colors.white.withOpacity(.2),
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

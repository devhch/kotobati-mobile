import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/modules/book_details/views/components/text_widget.dart';
import 'package:kotobati/app/modules/reading/views/components/book_widget.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';

import '../controllers/notes_controller.dart';

class NotesView extends GetView<NotesController> {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: (controller.notes.value)
                    ? Row(
                        key: UniqueKey(),
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: AppTheme.keyAppColor,
                                width: 1.0, // Underline thickness
                              ),
                            )),
                            child: Text(
                              "الملاحظات",
                              style: context.textTheme.headlineMedium!.copyWith(
                                fontSize: 24,
                                color: AppTheme.keyAppColor,
                              ),
                            ),
                          ),
                          const ContainerDivider(height: 30, width: 1),
                          TextButton(
                            onPressed: () {
                              controller.notes.update(
                                (_) {
                                  controller.notes.value = false;
                                },
                              );
                            },
                            child: Text(
                              "الإقتباسات",
                              style: context.textTheme.headlineMedium!.copyWith(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        key: UniqueKey(),
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              controller.notes.update(
                                (_) {
                                  controller.notes.value = true;
                                },
                              );
                            },
                            child: Text(
                              "الملاحظات",
                              style: context.textTheme.headlineMedium!.copyWith(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const ContainerDivider(height: 30, width: 1),
                          Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: AppTheme.keyAppColor,
                                width: 1.0, // Underline thickness
                              ),
                            )),
                            child: Text(
                              "الإقتباسات",
                              style: context.textTheme.headlineMedium!.copyWith(
                                fontSize: 24,
                                color: AppTheme.keyAppColor,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 25),
            Obx(
              () {
                if (controller.notes.value) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: controller.bookModel.notes.length,
                    itemBuilder: (_, int index) {
                      return TextWidget(
                        text: controller.bookModel.notes[index],
                      );
                    },
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: controller.bookModel.quotes.length,
                  itemBuilder: (_, int index) {
                    return TextWidget(
                      text: controller.bookModel.quotes[index],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

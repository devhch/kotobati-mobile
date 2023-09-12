/*
* Created By Mirai Devs.
* On 18/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/setting_objects_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/pdf_reader/controllers/pdf_reader_controller.dart';
import 'package:kotobati/app/modules/pdf_reader/views/components/add_note_to_book.dart';
import 'package:kotobati/app/modules/pdf_reader/views/components/brightness_bottom_sheet.dart';

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({
    super.key,
    required this.controller,
  });

  final PdfReaderController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.fullScreen,
      builder: (_, bool fullScreen, __) {
        return fullScreen
            ? Container()
            : Align(
                alignment: AlignmentDirectional.centerStart,
                child: ValueListenableBuilder<bool>(
                  valueListenable: controller.isExpandedOptions,
                  builder: (_, final bool isExpandedOptions, __) {
                    return Row(
                      children: <Widget>[
                        AnimatedContainer(
                          height: 240,
                          duration: const Duration(milliseconds: 1000),
                          padding:
                              isExpandedOptions ? const EdgeInsets.symmetric(horizontal: 8) : null,
                          decoration: const BoxDecoration(
                            color: AppTheme.keyAppLightGrayColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(48),
                              bottomLeft: Radius.circular(48),
                            ),
                          ),
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 100),
                            child: isExpandedOptions
                                ? Column(
                                    key: UniqueKey(),
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(height: 36),
                                      InkWell(
                                        onTap: () {
                                          BrightnessBottomSheet.show(
                                            brightness: controller.brightness,
                                            onChanged: (double newPage) async {
                                              controller.setReadingMode(newPage);
                                              miraiPrint('BrightOnChanged $newPage');

                                              final HiveDataStore hive = HiveDataStore();
                                              SettingObjectsModel setting =
                                                  await hive.getSettingObjects();
                                              setting.brightness = newPage;
                                              await hive.saveSettingObjects(
                                                  settingObjectsModel: setting);
                                            },
                                          );
                                          // controller.toggleReadingMode();
                                        },
                                        child: SvgPicture.asset(
                                          AppIconsKeys.idea,
                                          height: 38,
                                          width: 24,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Container(
                                        height: 1,
                                        color: AppTheme.keyAppGrayColorDark,
                                        width: 48,
                                      ),
                                      const SizedBox(height: 18),
                                      InkWell(
                                        onTap: () {
                                          AddNoteToBookDialog.show(
                                            book: controller.book,
                                            page: controller.savedPage.value.$1,
                                            callback: () {
                                              //controller.update();
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          AppIconsKeys.file,
                                          height: 26,
                                          width: 22,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Container(
                                        height: 1,
                                        color: AppTheme.keyAppGrayColorDark,
                                        width: 48,
                                      ),
                                      const SizedBox(height: 18),
                                      InkWell(
                                        onTap: () async {
                                          miraiPrint('Taking a quote...');
                                          await controller.takeQuote(context);
                                        },
                                        child: SvgPicture.asset(
                                          AppIconsKeys.edit,
                                          height: 26,
                                          width: 28,
                                          //    color: AppTheme.keyIconsGreyColor,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(height: 36),
                                    ],
                                  )
                                : SizedBox.shrink(key: UniqueKey()),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.isExpandedOptions.value =
                                !controller.isExpandedOptions.value;

                            // if (controller.isExpandedOptions.value) {
                            //   animationController.forward();
                            // } else {
                            //   animationController.reverse();
                            // }
                          },
                          child: Container(
                            width: 26,
                            height: 98,
                            // padding: const EdgeInsets.symmetric(
                            //   horizontal: 40,
                            //   vertical: 2,
                            // ),
                            decoration: const BoxDecoration(
                              color: AppTheme.keyAppGrayColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(26),
                                bottomLeft: Radius.circular(26),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: SvgPicture.asset(
                                AppIconsKeys.arrowBottom,
                                color: AppTheme.keyAppBlackColor,
                                width: 10,
                                height: 10,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
      },
    );
  }
}

/*
* Created By Mirai Devs.
* On 18/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/setting_objects_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/pdf_reader/controllers/pdf_reader_controller.dart';

class AppBarSettingsAction extends StatelessWidget {
  const AppBarSettingsAction({
    super.key,
    required GlobalKey<State<StatefulWidget>> menuKey,
    required this.controller,
  }) : _menuKey = menuKey;

  final GlobalKey<State<StatefulWidget>> _menuKey;
  final PdfReaderController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton<int>(
        key: _menuKey,
        elevation: 1,
        offset: const Offset(24, 0),
        padding: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        icon: SvgPicture.asset(
          AppIconsKeys.setting,
          fit: BoxFit.fill,
        ),
        color: AppTheme.keyAppLightGrayColor,
        //  color: AppTheme.keyAppColorDark,
        //  offset: Offset(1, -240),
        position: PopupMenuPosition.under,
        onSelected: (int index) {
          // switch (index) {
          //   case 0:
          //     controller.selectedFilerStadium.value = null;
          //     break;
          //
          //   case 1:
          //     controller.selectedFilerStadium.value = false;
          //     break;
          //
          //   case 2:
          //     controller.selectedFilerStadium.value = true;
          //     break;
          // }
          //
          // controller.changeStadiumFilter();
        },

        itemBuilder: (_) {
          return <PopupMenuEntry<int>>[
            PopupMenuItem<int>(
              value: 0,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                return InkWell(
                  onTap: () async {
                    controller.isVertical = !controller.isVertical;
                    controller.update();
                    setState(() {});

                    /// Save To Hive...
                    final HiveDataStore hive = HiveDataStore();
                    SettingObjectsModel setting = await hive.getSettingObjects();
                    setting.horizontal = !controller.isVertical;
                    await hive.saveSettingObjects(settingObjectsModel: setting);
                  },
                  child: Container(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(10),
                    color: AppTheme.keyMenuItemGrayColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'قلب الصفحة',
                          style: Get.theme.textTheme.bodyText2!.copyWith(
                              //  color: AppTheme.keyDarkBlueColor,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                controller.isVertical ? 'عمودي' : 'أفقي',
                                style: Get.theme.textTheme.headlineSmall!.copyWith(
                                  fontSize: 16,
                                  //  color: AppTheme.keyDarkBlueColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: controller.isVertical ? 0 : 1,
                              child: SvgPicture.asset(
                                AppIconsKeys.arrowBottom,
                                fit: BoxFit.fill,
                                height: 14,
                                width: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            PopupMenuItem<int>(
              value: 1,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                return InkWell(
                  onTap: () async {
                    controller.isDarkMode = !controller.isDarkMode;
                    controller.update();

                    setState(() {});

                    /// Save To Hive...
                    final HiveDataStore hive = HiveDataStore();
                    SettingObjectsModel setting = await hive.getSettingObjects();
                    setting.darkMode = controller.isDarkMode;
                    await hive.saveSettingObjects(settingObjectsModel: setting);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.all(10),
                    color: AppTheme.keyMenuItemGrayColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'وضع القراءة',
                          style: Get.theme.textTheme.bodyText2!.copyWith(
                              //  color: AppTheme.keyDarkBlueColor,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                controller.isDarkMode ? 'ليلي' : 'النهار',
                                style: Get.theme.textTheme.headlineSmall!.copyWith(
                                  fontSize: 16,
                                  //  color: AppTheme.keyDarkBlueColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: controller.isDarkMode ? 0 : 1,
                              child: SvgPicture.asset(
                                AppIconsKeys.arrowBottom,
                                fit: BoxFit.fill,
                                height: 14,
                                width: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            PopupMenuItem<int>(
              value: 2,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                return Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  color: AppTheme.keyMenuItemGrayColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'هامش الصفحة',
                        style: Get.theme.textTheme.bodyText2!.copyWith(
                            //  color: AppTheme.keyDarkBlueColor,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      //     const SizedBox(height: 6),
                      Slider.adaptive(
                        value: controller.pagePadding.value,
                        min: 0,
                        max: 40,
                        label: '${controller.pagePadding.value.floor()}',
                        inactiveColor: AppTheme.keySliderInactiveColor,
                        onChanged: (double newPadding) async {
                          /// Save To Hive...
                          final HiveDataStore hive = HiveDataStore();
                          SettingObjectsModel setting = await hive.getSettingObjects();

                          controller.isPaddingChanging.value = newPadding != setting.spacing;
                          controller.isPaddingChanging.notifyListeners();
                          miraiPrint('isPaddingChanging: ${controller.isPaddingChanging.value}');

                          controller.pagePadding.value = newPadding;
                          controller.pagePadding.notifyListeners();
                      //    controller.update();

                          setState(() {});


                        },
                        // onChangeStart: (double startValue) {
                        //   controller.update();
                        //   miraiPrint('=============');
                        //   miraiPrint('onChangeStart');
                        //   miraiPrint('isPaddingChanging: ${controller.isPaddingChanging.value}');
                        //   miraiPrint('=============');
                        //   controller.isPaddingChanging.value = true;
                        //   controller.isPaddingChanging.notifyListeners();
                        //   miraiPrint('=============');
                        //   miraiPrint('isPaddingChanging: ${controller.isPaddingChanging.value}');
                        //   miraiPrint('=============');
                        // },
                        onChangeEnd: (double endValue) async {
                          miraiPrint('=============');
                          miraiPrint('onChangeEnd');
                          miraiPrint('isPaddingChanging: ${controller.isPaddingChanging.value}');
                          miraiPrint('=============');
                          controller.isPaddingChanging.value = false;
                          controller.isPaddingChanging.notifyListeners();
                          miraiPrint('=============');
                          miraiPrint('isPaddingChanging: ${controller.isPaddingChanging.value}');
                          miraiPrint('=============');
                          /// Save To Hive...
                          final HiveDataStore hive = HiveDataStore();
                          SettingObjectsModel setting = await hive.getSettingObjects();

                          setting.spacing = endValue;
                          await hive.saveSettingObjects(settingObjectsModel: setting);
                          controller.update();
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
          ];
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndiro_five/app/core/utils/app_icons_keys.dart';
import 'package:ndiro_five/app/core/utils/app_language_keys.dart';

/*
* Created By Mirai Devs.
* On 22/6/2023.
*/

class MiraiTabIcon {
  MiraiTabIcon({
    required this.icon,
    required this.selectedIcon,
    this.index = 0,
    this.isSelected = false,
    this.isSelectedIconHasAColor = false,
    this.title,
    this.animationController,
  });

  String icon;
  String selectedIcon;
  bool isSelectedIconHasAColor;
  bool isSelected;
  int? index;
  String? title;
  AnimationController? animationController;

  static List<MiraiTabIcon> tabIconsList = <MiraiTabIcon>[
    MiraiTabIcon(
      index: 0,
      title: AppLanguagesKeys.keyHome.tr,
      icon: AppIconsKeys.keyHomeIcon,
      selectedIcon: AppIconsKeys.keySelectedHomeIcon,
      isSelected: true,
      animationController: null,
    ),
    MiraiTabIcon(
      index: 1,
      title: AppLanguagesKeys.keyEvents.tr,
      icon: AppIconsKeys.keyEventsIcon,
      selectedIcon: AppIconsKeys.keySelectedEventsIcon,
      isSelectedIconHasAColor: true,
      isSelected: false,
      animationController: null,
    ),
    MiraiTabIcon(
      index: 2,
      title: AppLanguagesKeys.keyPartners.tr,
      icon: AppIconsKeys.keyPartnersIcon,
      selectedIcon: AppIconsKeys.keySelectedPartnersIcon,
      isSelectedIconHasAColor: true,
      isSelected: false,
      animationController: null,
    ),
    MiraiTabIcon(
      icon: AppIconsKeys.keyProfileIcon,
      selectedIcon: AppIconsKeys.keyProfileIcon,
      index: 3,
      title: AppLanguagesKeys.keyProfile.tr,
      isSelected: false,
      animationController: null,
    ),
  ];
}

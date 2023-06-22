import 'package:flutter/material.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';

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
    this.animationController,
  });

  String icon;
  String selectedIcon;
  bool isSelectedIconHasAColor;
  bool isSelected;
  int? index;
  AnimationController? animationController;

  static List<MiraiTabIcon> tabIconsList = <MiraiTabIcon>[
    MiraiTabIcon(
      index: 0,
      icon: AppIconsKeys.world,
      selectedIcon: AppIconsKeys.world,
      isSelected: true,
      animationController: null,
    ),
    MiraiTabIcon(
      index: 1,
      icon: AppIconsKeys.books,
      selectedIcon: AppIconsKeys.books,
      isSelectedIconHasAColor: true,
      isSelected: false,
      animationController: null,
    ),
    MiraiTabIcon(
      index: 2,
      icon: AppIconsKeys.recent,
      selectedIcon: AppIconsKeys.recent,
      isSelectedIconHasAColor: true,
      isSelected: false,
      animationController: null,
    ),
    MiraiTabIcon(
      icon: AppIconsKeys.file,
      selectedIcon: AppIconsKeys.file,
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}

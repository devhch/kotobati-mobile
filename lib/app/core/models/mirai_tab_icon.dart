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
    required this.size,
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
  Size size;
  AnimationController? animationController;

  static List<MiraiTabIcon> tabIconsList = <MiraiTabIcon>[
    MiraiTabIcon(
      index: 0,
      size: const Size(30, 30),
      icon: AppIconsKeys.web,
      selectedIcon: AppIconsKeys.webSelected,
      isSelected: true,
      animationController: null,
    ),
    MiraiTabIcon(
      index: 1,
      size: const Size(38, 30),
      icon: AppIconsKeys.books,
      selectedIcon: AppIconsKeys.booksSelected,
      isSelectedIconHasAColor: true,
      isSelected: false,
      animationController: null,
    ),
    MiraiTabIcon(
      index: 2,
      size: const Size(40, 26),
      icon: AppIconsKeys.recent,
      selectedIcon: AppIconsKeys.recentSelected,
      isSelectedIconHasAColor: true,
      isSelected: false,
      animationController: null,
    ),
    MiraiTabIcon(
      icon: AppIconsKeys.file,
      size: const Size(26, 30),
      selectedIcon: AppIconsKeys.fileSelected,
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}

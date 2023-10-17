/*
* Created By Mirai Devs.
* On 22/9/2022.
*/
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/mirai_tab_icon.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

class MiraiBottomBarView extends StatefulWidget {
  const MiraiBottomBarView({
    Key? key,
    required this.tabIconsList,
    required this.addClick,
    required this.changeIndex,
    required this.orientation,
    required this.isScrolling,
    required this.isFabBarAdding,
    this.controller,
    this.animationScaleOut,
    this.animationScaleIn,
  }) : super(key: key);

  final Function(int index) changeIndex;
  final List<MiraiTabIcon> tabIconsList;
  final VoidCallback addClick;
  final Orientation orientation;

  final AnimationController? controller;
  final Animation<double>? animationScaleOut;
  final Animation<double>? animationScaleIn;
  final ValueNotifier<bool> isScrolling;
  final ValueNotifier<bool> isFabBarAdding;

  @override
  State<MiraiBottomBarView> createState() => _MiraiBottomBarViewState();
}

class _MiraiBottomBarViewState extends State<MiraiBottomBarView> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isScrolling,
      builder: (_, bool isScrolling, __) {
        if (isScrolling) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
        return ValueListenableBuilder<bool>(
          valueListenable: widget.isFabBarAdding,
          builder: (_, bool isFabBarAdding, __) {
            return Container(
              height: MiraiSize.bottomNavBarHeight94 + 8,
              width: Get.width,
              decoration: BoxDecoration(
                boxShadow: isScrolling
                    ? <BoxShadow>[]
                    : <BoxShadow>[
                        const BoxShadow(
                          blurRadius: 24,
                          color: Color.fromRGBO(42, 86, 118, .16),
                          offset: Offset(0, 60),
                        ),
                      ],
              ),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 150),
                    left: 0,
                    right: 0,
                    bottom: isScrolling ? -100 : 0,
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget? child) {
                        return Transform(
                          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                          child: PhysicalShape(
                            elevation: 0,
                            clipper: TabClipper(
                              radius: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                        CurvedAnimation(
                                          parent: animationController,
                                          curve: Curves.fastOutSlowIn,
                                        ),
                                      )
                                      .value *
                                  (28.0),
                              isFab: isFabBarAdding,
                            ),
                            color: AppTheme.keyBlackGreyColor,
                            child: buildColumn(context, isFabBarAdding),
                          ),
                        );
                      },
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    /*  bottom: widget.navHeight -
                        (Platform.isIOS
                            ? MiraiSize.space10
                            : MiraiSize.space24),*/
                    bottom: isScrolling || isFabBarAdding
                        ? -(Platform.isIOS
                            ? MiraiSize.bottomNavBarHeight94
                            : MiraiSize.bottomNavBarHeight70)
                        : (Platform.isIOS
                                ? MiraiSize.bottomNavBarHeight94
                                : MiraiSize.bottomNavBarHeight70) -
                            MiraiSize.iconSize70 / 2,
                    child: ScaleTransition(
                      alignment: Alignment.center,
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                      child: _BuildAddContainer(
                        addClick: widget.addClick,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  SizedBox buildColumn(BuildContext context, bool isFabBarAdding) {
    return SizedBox(
      height: Platform.isIOS ? MiraiSize.bottomNavBarHeight94 : MiraiSize.bottomNavBarHeight70,
      child: Row(
        children: <Widget>[
          Expanded(child: _buildTabIcons(index: 0)),
          Expanded(child: _buildTabIcons(index: 1)),
          AnimatedSize(
            duration: const Duration(milliseconds: 100),
            child: SizedBox(
              width: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(
                        CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
                      )
                      .value *
                  (isFabBarAdding ? 0 : 64.0),
            ),
          ),
          Expanded(child: _buildTabIcons(index: 2)),
          Expanded(child: _buildTabIcons(index: 3)),
        ],
      ),
    );
  }

  TabIcons _buildTabIcons({
    required int index,
  }) {
    return TabIcons(
      index: index,
      tabIconData: widget.tabIconsList[index],
      removeAllSelect: () {
        setRemoveAllSelection(widget.tabIconsList[index]);
        widget.changeIndex(index);
      },
    );
  }

  void setRemoveAllSelection(MiraiTabIcon tabIconData) {
    if (!mounted) return;
    setState(() {
      for (MiraiTabIcon tab in widget.tabIconsList) {
        tab.isSelected = false;
        if (tabIconData.index == tab.index) {
          tab.isSelected = true;
        }
      }
    });
  }
}

class _BuildAddContainer extends StatelessWidget {
  const _BuildAddContainer({
    Key? key,
    required this.addClick,
  }) : super(key: key);

  final VoidCallback addClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: addClick,

      //shape: const CircleBorder(),
      // containerShape: BoxShape.circle,
      // overlayColor: Colors.white.withOpacity(.2),
      // backgroundColor: AppTheme.keyAppColor,
      // boxShadow: <BoxShadow>[
      //   BoxShadow(
      //     color: AppTheme.keyAppColor,
      //     offset: const Offset(0.0, 3.0),
      //     blurRadius: 2.0,
      //   ),
      // ],
      child: Image.asset(
        AppIconsKeys.addBooks,
        width: MiraiSize.iconSize70,
        height: MiraiSize.iconSize70,
        //color: Colors.white,
        // width: MiraiSize.iconSize30,
        fit: BoxFit.fill,
      ),
    );
    // return MiraiElevatedButtonWidget(
    //   onTap: addClick,
    //   width: MiraiSize.iconSize58,
    //   height: MiraiSize.iconSize58,
    //   shape: const CircleBorder(),
    //   containerShape: BoxShape.circle,
    //   overlayColor: Colors.white.withOpacity(.2),
    //   // backgroundColor: Theme.of(context).primaryColor,
    //   boxShadow: <BoxShadow>[
    //     BoxShadow(
    //       color: Colors.black.withOpacity(0.4),
    //       offset: const Offset(0.0, 3.0),
    //       blurRadius: 2.0,
    //     ),
    //   ],
    //   child: Image.asset(
    //     AppIconsKeys.addBooks,
    //     // color: Colors.white,
    //     // width: MiraiSize.iconSize30,
    //     fit: BoxFit.fill,
    //   ),
    // );
  }
}

class TabIcons extends StatefulWidget {
  const TabIcons({
    Key? key,
    required this.tabIconData,
    required this.removeAllSelect,
    required this.index,
    this.controller,
    this.animationScaleOut,
    this.animationScaleIn,
  }) : super(key: key);

  final MiraiTabIcon tabIconData;
  final Function removeAllSelect;
  final int index;
  final AnimationController? controller;
  final Animation<double>? animationScaleOut;
  final Animation<double>? animationScaleIn;

  @override
  State<TabIcons> createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.removeAllSelect();
          widget.tabIconData.animationController?.reverse();
        }
      });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        if (!widget.tabIconData.isSelected) {
          setAnimation();
        }
      },
      child: IgnorePointer(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            ScaleTransition(
              alignment: Alignment.center,
              scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                CurvedAnimation(
                  parent: widget.tabIconData.animationController!,
                  curve: const Interval(
                    0.1,
                    1.0,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
              ),
              child: Image.asset(
                widget.tabIconData.isSelected
                    ? widget.tabIconData.selectedIcon
                    : widget.tabIconData.icon,
                fit: BoxFit.fill,
                key: ValueKey<bool>(widget.tabIconData.isSelected),
                width: (widget.tabIconData.isSelected ? 20 : 0) + widget.tabIconData.size.width,
                height: (widget.tabIconData.isSelected ? 20 : 0) + widget.tabIconData.size.height,
              ),
            ),
            Positioned(
              top: 4,
              left: 6,
              right: 0,

              child: ScaleTransition(
                alignment: Alignment.center,
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.tabIconData.animationController!,
                    curve: const Interval(
                      0.2,
                      1.0,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.keyAppColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // child: Container(
              //   width: 8,
              //   height: 8,
              //   decoration: const BoxDecoration(
              //     color: AppTheme.keyAppColor,
              //     shape: BoxShape.circle,
              //   ),
              // ),
            ),
            Positioned(
              top: 0,
              left: 16,
              bottom: 8,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.tabIconData.animationController!,
                    curve: const Interval(
                      0.5,
                      0.8,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppTheme.keyAppColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // child: Container(
              //   width: 4,
              //   height: 4,
              //   decoration: const BoxDecoration(
              //     color: AppTheme.keyAppColor,
              //     shape: BoxShape.circle,
              //   ),
              // ),
            ),
            Positioned(
              top: 6,
              right: 16,
              bottom: 0,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.tabIconData.animationController!,
                    curve: const Interval(
                      0.5,
                      0.6,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.keyAppColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // child: Container(
              //   width: 6,
              //   height: 6,
              //   decoration: const BoxDecoration(
              //     color: AppTheme.keyAppColor,
              //     shape: BoxShape.circle,
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  TabClipper({
    this.radius = 38.0,
    required this.isFab,
  });

  final double radius;
  final bool isFab;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2.4;
    path.lineTo(0, 0);
    path.arcTo(
      Rect.fromLTWH(0, 0, radius, radius),
      degreeToRadians(180),
      degreeToRadians(90),
      false,
    );
    path.arcTo(
      Rect.fromLTWH(
        ((size.width / 2) - v / 2) - radius + v * 0.04 - 10,
        0,
        (isFab ? 200 : radius) + 10,
        (isFab ? 1000 : radius) + 10,
      ),
      degreeToRadians(270),
      degreeToRadians(60),
      false,
    );

    path.arcTo(
      Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
      degreeToRadians(150),
      degreeToRadians(-120),
      false,
    );

    path.arcTo(
      Rect.fromLTWH(
        (size.width - ((size.width / 2) - v / 2)) - v * 0.04,
        0,
        (isFab ? 0 : radius) + 10,
        (isFab ? 0 : radius) + 10,
      ),
      degreeToRadians(200),
      degreeToRadians(60),
      false,
    );

    path.arcTo(
      Rect.fromLTWH(size.width - radius, 0, radius, radius),
      degreeToRadians(270),
      degreeToRadians(80),
      false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final double redian = (math.pi / 180) * degree;
    return redian;
  }
}

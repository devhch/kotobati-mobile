/*
* Created By Mirai Devs.
* On 24/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';

class MiraiContainerWidget extends StatelessWidget {
  const MiraiContainerWidget({
    Key? key,
    required this.child,
    this.backgroundColor = AppTheme.keyAppColor,
    this.borderRadius,
    this.boxShadow,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.border,
    this.showShadow = false,
    this.shape,
    this.containerShape = BoxShape.rectangle,
    this.rounded = false,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final BoxBorder? border;
  final bool showShadow;
  final OutlinedBorder? shape;
  final BoxShape containerShape;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: containerShape,
        borderRadius: containerShape == BoxShape.circle
            ? null
            : borderRadius ??
                BorderRadius.circular(
                  rounded ? 28 : 8,
                ),
        border: border,
        boxShadow: showShadow
            ? boxShadow ??
                const <BoxShadow>[
                  BoxShadow(
                    blurRadius: 20.0,
                    color: Color.fromRGBO(0, 0, 0, .06),
                    offset: Offset(0.0, 3.0),
                  ),
                ]
            : null,
      ),
      child: child,
    );
  }
}

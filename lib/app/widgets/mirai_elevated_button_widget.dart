/*
* Created By Mirai Devs.
* On 21/9/2022.
*/
import 'package:flutter/material.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';

class MiraiElevatedButtonWidget extends StatelessWidget {
  const MiraiElevatedButtonWidget({
    Key? key,
    required this.child,
    required this.onTap,
    this.backgroundColor = AppTheme.keyAppColor,
    this.borderRadius,
    this.overlayColor,
    this.boxShadow,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.onLongPress,
    this.side,
    this.showShadow = false,
    this.shape,
    this.containerShape = BoxShape.rectangle,
    this.rounded = false,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;
  final Color? overlayColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final BorderSide? side;
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: borderRadius ??
                    BorderRadius.circular(
                      rounded ? 28 : 2,
                    ),
              ),
          side: side,
        ).copyWith(
          elevation: MaterialStateProperty.all(0),
          overlayColor: MaterialStateProperty.all(
            overlayColor ?? AppTheme.keyAppColor.withOpacity(.2),
          ),
        ),
        onPressed: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}

/*
* Created By Mirai Devs.
* On 24/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

import '../core/utils/app_enums.dart';

class SwitchLoginState extends StatelessWidget {
  const SwitchLoginState({
    Key? key,
    required this.child,
    required this.response,
    this.expandLoading = false,
    this.colorLoading = Colors.white,
    this.size,
  }) : super(key: key);

  final Widget child;
  final MiraiResponseEnum response;
  final bool expandLoading;
  final Color colorLoading;
  final double? size;

  @override
  Widget build(BuildContext context) {
    switch (response) {
      case MiraiResponseEnum.loading:
        return Row(
          mainAxisSize: expandLoading ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitSpinningLines(
              color: colorLoading,
              size: size ?? MiraiSize.iconSize24,
            ),
          ],
        );
      case MiraiResponseEnum.completed:
        return SpinKitPulse(
          color: Colors.white,
          size: MiraiSize.iconSize26,
        );
      default:
        return child;
    }
  }
}

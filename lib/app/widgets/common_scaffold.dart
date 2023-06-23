/*
* Created By Mirai Devs.
* On 6/22/2023.
*/
import 'package:flutter/material.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';

import 'common_app_bar_widget.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    Key? key,
    required this.child,
    this.backButton = false,
  }) : super(key: key);
  final bool backButton;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.keyAppBlackColor,
      body: Column(
        children: <Widget>[
          CommonAppBarWidget(backButton: backButton),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

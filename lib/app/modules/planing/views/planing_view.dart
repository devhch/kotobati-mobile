import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/widgets/card_text_icon_widget.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';

import '../controllers/planing_controller.dart';

class PlaningView extends GetView<PlaningController> {
  const PlaningView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              CardTextIconWidget(
                text: "كتب  أقرأها",
                icon: AppIconsKeys.edit,
              ),
              SizedBox(height: 8),
              CardTextIconWidget(
                text: "كتب سأقرأها",
                icon: AppIconsKeys.edit,
              ),
              SizedBox(height: 8),
              CardTextIconWidget(
                text: "كتب قرأتها",
                icon: AppIconsKeys.edit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

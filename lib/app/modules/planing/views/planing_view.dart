import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/modules/planing/views/components/add_dialog.dart';
import 'package:kotobati/app/widgets/card_text_icon_widget.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';

import '../controllers/planing_controller.dart';

class PlaningView extends GetView<PlaningController> {
  const PlaningView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Obx(
                () {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: listPlaningBooks.length,
                    itemBuilder: (_, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: CardTextIconWidget(
                          planingBooksModel: listPlaningBooks[index],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 50),
              IconButton(
                iconSize: 55,
                onPressed: () {
                  AddDialog.showAddDialog();
                },
                icon: SvgPicture.asset(
                  AppIconsKeys.addCollection,
                  width: 55,
                  height: 55,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/widgets/mirai_text_field_widget.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchControllerC> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchControllerC>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.keyAppBlackColor,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    IconButton(
                      iconSize: 55,
                      splashRadius: 2,
                      onPressed: () {
                        Get.back();
                      },
                      icon: SvgPicture.asset(AppIconsKeys.backArrowCircle),
                    ),
                    Expanded(
                      child: MiraiTextFieldWidget(
                        controller: controller.txtController,
                        hint: "بحث...",
                        fillColor: const Color(0xffA1A1A1),
                        borderColor: const Color(0xffA1A1A1),
                      ),
                    ),
                    IconButton(
                      iconSize: 55,
                      splashRadius: 2,
                      onPressed: () {},
                      icon: SvgPicture.asset(AppIconsKeys.search),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: controller.searchForPDFs,
                        child: const Text('Search for PDFs'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.pdfFiles.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(controller.pdfFiles[index].path),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*
* Created By Mirai Devs.
* On 18/7/2023.
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/modules/pdf_reader/controllers/pdf_reader_controller.dart';

class SliderBottomWidget extends StatelessWidget {
  const SliderBottomWidget({
    super.key,
    required this.controller,
  });

  final PdfReaderController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isPdfLoaded,
      builder: (_, bool isPdfLoaded, __) {
        if (isPdfLoaded) {
          return Container(
            // height: 78,
            color: AppTheme.keyAppLightGrayColor,
            child: ValueListenableBuilder<(int, int)>(
              valueListenable: controller.savedPage,
              builder: (_, (int, int) savedPage, __) {
                final (int page, int total) = savedPage;
                return Column(
                  children: <Widget>[
                    const SizedBox(height: 16),
                    Slider.adaptive(
                      value: page.toDouble(),
                      min: 0,
                      max: total.toDouble(),
                      label: '${page + 1}',
                      inactiveColor: AppTheme.keySliderInactiveColor,
                      onChanged: (double newPage) {
                        controller.savedPage.value = (newPage.toInt(), total);
                        controller.pdfViewerController?.setPage(newPage.toInt());

                        // controller.pdfViewerController?.jumpToPage(newPage.toInt());
                      },
                    ),
                    Text(
                      '${page + 1}/$total',
                      style: Get.theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

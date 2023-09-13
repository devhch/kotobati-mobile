/*
* Created By Mirai Devs.
* On 12/9/2023.
*/

import 'package:flutter/material.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/modules/search/controllers/search_controller.dart';
import 'package:get/get.dart';
import 'package:wave_linear_progress_indicator/wave_linear_progress_indicator.dart';

class SearchProgressWidget extends StatelessWidget {
  const SearchProgressWidget({
    super.key,
    required this.controller,
  });

  final SearchPDFController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      key: ValueKey<String>(
        "ValueListenableBuilderWhileDownloading${DateTime.now().toIso8601String()}",
      ),
      valueListenable: controller.downloadProgress,
      builder: (_, int downloadProgress, __) {
        final double progress = downloadProgress / (controller.total != 0 ? controller.total : 1);

        if (progress == 0) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'يتم تحميل ${controller.total} كتاب من الجهاز',
                style: context.textTheme.displayLarge!.copyWith(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              WaveLinearProgressIndicator(
                value: progress,
                enableBounceAnimation: false,
                waveColor: AppTheme.keyAppColor,
                color: AppTheme.keyAppColor,
                borderRadius: 30,
                labelDecoration: BoxDecoration(
                  color: AppTheme.keyAppColorDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                waveBackgroundColor: AppTheme.keyAppColorDark,
                backgroundColor: Colors.grey[400],
                // minHeight: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}

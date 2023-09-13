/*
* Created By Mirai Devs.
* On 12/9/2023.
*/

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/modules/search/controllers/search_controller.dart';

import 'search_progress_widget.dart';

class GetPdfFilesWidget extends StatelessWidget {
  const GetPdfFilesWidget({
    super.key,
    required this.controller,
  });

  final SearchPDFController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: ValueKey<String>(
        "SearchViewCenter${DateTime.now().toIso8601String()}",
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: (controller.total == 0 || controller.total == 1)
              ? Column(
                  key: ValueKey<String>(
                    "ColumnWhileDownloading${DateTime.now().toIso8601String()}",
                  ),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // const CircularProgressIndicator(),
                    // const SizedBox(height: 20),
                    Text(
                      'محاولة تحميل جميع ملفات\n pdf من الجهاز',
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      ' يرجى التحلي بالصبر لأن العملية\n قد تستغرق وقت...',
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    DefaultTextStyle(
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 30.0,
                      ),
                      child: AnimatedTextKit(
                        key: const ValueKey<int>(0),
                        totalRepeatCount: 30,
                        animatedTexts: <TypewriterAnimatedText>[
                          TypewriterAnimatedText(
                            'جاري التحميل...',
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SearchProgressWidget(controller: controller),
        ),
      ),
    );
  }
}

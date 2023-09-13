/*
* Created By Mirai Devs.
* On 12/9/2023.
*/

import 'package:flutter/material.dart';
import 'package:kotobati/app/core/models/mirai_pdf_model.dart';
import 'package:kotobati/app/modules/search/controllers/search_controller.dart';

import 'search_pdf_item_widget.dart';
import 'package:get/get.dart';

class PdfFilesFromDevice extends StatelessWidget {
  const PdfFilesFromDevice({
    super.key,
    required this.controller,
  });

  final SearchPDFController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MiraiPDF>>(
      valueListenable: controller.pdfFilesForSearch,
      builder: (_, List<MiraiPDF> pdfFilesForSearch, __) {
        if (pdfFilesForSearch.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            cacheExtent: double.infinity,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: pdfFilesForSearch.length,
            itemBuilder: (BuildContext context, int index) {
              final MiraiPDF pdf = pdfFilesForSearch[index];
              
              return SearchPDFItemWidget(
                pdfWidthImage: pdf,
                controller: controller,
              );
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Text(
                'لم يتم العثور على كتاب\n مثل هذا في جهازك.',
                style: context.textTheme.displayLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

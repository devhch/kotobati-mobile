/*
* Created By Mirai Devs.
* On 12/9/2023.
*/

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotobati/app/core/models/mirai_pdf_model.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/search/controllers/search_controller.dart';

import 'search_pdf_item_widget.dart';

class PdfFilesFromHive extends StatelessWidget {
  const PdfFilesFromHive({
    super.key,
    required this.controller,
  });

  final SearchPDFController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Map<dynamic, dynamic>>>(
      valueListenable: HiveDataStore().miraiPDFsListenable(),
      builder: (_, Box<Map<dynamic, dynamic>> box, __) {
        final List<Map<dynamic, dynamic>> miraiPDFs = box.values.toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: miraiPDFs.length,
          itemBuilder: (BuildContext context, int index) {
            final MiraiPDF pdf = MiraiPDF.fromJson(miraiPDFs[index]);
            return SearchPDFItemWidget(
              pdfWidthImage: pdf,
              controller: controller,
            );
          },
        );
      },
    );
  }
}

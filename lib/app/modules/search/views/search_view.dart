import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_extension.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/widgets/sliver_app_bar_delegate.dart';

import '../controllers/search_controller.dart';
import 'components/get_pdf_files_widget.dart';
import 'components/pdf_file_from_hive_widget.dart';
import 'components/pdf_files_from_device_widget.dart';
import 'components/search_history_listenable_widget.dart';
import 'components/search_no_data_widget.dart';
import 'components/search_text_field_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late SearchPDFController controller;

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SearchPDFController>();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  final GlobalKey keySearchWidget = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.keyAppBlackColor,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.keyAppBlackColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: GetBuilder<SearchPDFController>(
            init: controller,
            builder: (_) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: controller.pdfPaths.isNotEmpty
                    ? ListView(
                        children: <Widget>[
                          SearchTextFieldWidget(
                            // key: keySearchWidget,
                            controller: controller,
                            textEditingController: textEditingController,
                          ),
                          const SizedBox(height: 10),
                          const SearchHistoryValueListenable(),
                          // if (controller.isPDFsFromHive)
                          //   PdfFilesFromHive(controller: controller)
                          // else
                          PdfFilesFromDevice(controller: controller),
                        ],
                      )
                    : controller.isDoneSearching
                        ? const SearchNoDataWidget()
                        : GetPdfFilesWidget(controller: controller),
              );
            },
          ),
        ),
      ),
    );
  }
}

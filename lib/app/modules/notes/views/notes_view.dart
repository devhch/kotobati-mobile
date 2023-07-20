import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/modules/book_details/views/components/text_widget.dart';
import 'package:kotobati/app/modules/reading/views/components/book_widget.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';
import 'package:mirai_responsive/mirai_responsive.dart';

import '../controllers/notes_controller.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> with SingleTickerProviderStateMixin {
  /// NotesController
  final NotesController controller = Get.find<NotesController>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Column(
        children: <Widget>[
          //  const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _tabController.animateTo(0);
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        // color: AppTheme.keyAppColor,
                        color: _tabController.index == 0
                            ? AppTheme.keyAppColor
                            : Colors.transparent,
                        width: 1.0, // Underline thickness
                      ),
                    ),
                  ),
                  child: Text(
                    "الملاحظات",
                    style: context.textTheme.headlineMedium!.copyWith(
                      fontSize: 24,
                      color: _tabController.index == 0
                          ? AppTheme.keyAppColor
                          : AppTheme.keyAppGrayColorDark,
                    ),
                  ),
                ),
              ),
              const ContainerDivider(height: 30, width: 1),
              GestureDetector(
                onTap: () {
                  _tabController.animateTo(1);
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        // color: AppTheme.keyAppColor,
                        color: _tabController.index == 1
                            ? AppTheme.keyAppColor
                            : Colors.transparent,
                        width: 1.0, // Underline thickness
                      ),
                    ),
                  ),
                  child: Text(
                    "الإقتباسات",
                    style: context.textTheme.headlineMedium!.copyWith(
                      fontSize: 24,
                      color: _tabController.index == 1
                          ? AppTheme.keyAppColor
                          : AppTheme.keyAppGrayColorDark,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 45),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                if (controller.bookModel.notes!.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    //  physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: MiraiSize.bottomNavBarHeight94),
                    itemCount: controller.bookModel.notes!.length,
                    itemBuilder: (_, int index) {
                      return TextWidget(
                        title: controller.bookModel.title!,
                        text: controller.bookModel.notes![index],
                      );
                    },
                  )
                else
                  const Center(child: Text('No Data')),
                if (controller.bookModel.quotes!.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: MiraiSize.bottomNavBarHeight94),
                    itemCount: controller.bookModel.quotes!.length,
                    itemBuilder: (_, int index) {
                      return Container();
                      // return TextWidget(
                      //   text: controller.bookModel.quotes![index],
                      // );
                    },
                  )
                else
                  const Center(child: Text('No Data')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/reading/views/components/book_widget.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';
import 'package:kotobati/app/widgets/delete_one_book_widget.dart';
import 'package:kotobati/app/widgets/mirai_cached_image_network_widget.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
import 'package:kotobati/app/widgets/mirai_verifying_dialog.dart';

import '../../pdf_reader/views/components/planing_bottom_sheet.dart';
import '../controllers/book_details_controller.dart';
import 'components/text_widget.dart';

class BookDetailsView extends StatefulWidget {
  const BookDetailsView({Key? key}) : super(key: key);

  @override
  State<BookDetailsView> createState() => _BookDetailsViewState();
}

class _BookDetailsViewState extends State<BookDetailsView>
    with SingleTickerProviderStateMixin {
  /// BookDetailsController
  final BookDetailsController controller = Get.find<BookDetailsController>();

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.keyAppBlackColor,
      ),
      child: CommonScaffold(
        backButton: true,
        child: GetBuilder<BookDetailsController>(
          builder: (_) {
            return Column(
              children: <Widget>[
                //     const SizedBox(height: 15),
                Container(
                  // padding: const EdgeInsets.symmetric(
                  //   horizontal: 16,
                  //   vertical: 10,
                  // ),
                  height: 140,
                  width: 96,
                  decoration: const BoxDecoration(
                      // color: AppTheme.keyAppColor,
                      ),
                  child: controller.book.image != null &&
                          controller.book.image!.contains(".svg")
                      ? SvgPicture.network(
                          controller.book.image!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          // width: MiraiSize.iconSize24,
                          // height: MiraiSize.iconSize24,
                        )
                      : MiraiCachedImageNetworkWidget(
                          imageUrl: controller.book.image!,
                          fit: BoxFit.fill,
                          width: 96,
                          //  width: double.infinity,
                          //    width: MiraiSize.iconSize24,
                          title: controller.book.title!,
                          // height: MiraiSize.iconSize24,
                          // color: AppTheme.keyAppBlackColor,
                        ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    controller.book.title!,
                    style: context.textTheme.headlineMedium!.copyWith(
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  controller.book.author!,
                  style: context.textTheme.headlineMedium!.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 16),
                if (controller.book.path != null)
                  MiraiElevatedButtonWidget(
                    // height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    overlayColor: Colors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(8),
                    child: const Text("قراءة الكتاب"),
                    onTap: () async {
                      miraiPrint("Send Book ${controller.book.toString()}");
                      Get.toNamed(
                        Routes.pdfReader,
                        arguments: controller.book,
                      );
                      // miraiPrint("New Book ${newBook.toString()}");
                      //
                      // if (newBook is Book &&
                      //     newBook.toString() != controller.book.toString()) {
                      //   controller.book = newBook;
                      //   controller.update();
                      // }
                    },
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        controller.book.planingBook = listPlaningBooks[0];
                        await HiveDataStore().updateBook(book: controller.book);
                        controller.update();
                      },
                      child: SvgPicture.asset(
                        AppIconsKeys.reading,
                        width: 16,
                        colorFilter: controller.book.planingBook != null &&
                                controller.book.planingBook!.id == 1
                            ? const ColorFilter.mode(
                                AppTheme.keyAppColor,
                                BlendMode.srcIn,
                              )
                            : null,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () async {
                        controller.book.planingBook = listPlaningBooks[1];
                        await HiveDataStore().updateBook(book: controller.book);
                        controller.update();
                      },
                      child: SvgPicture.asset(
                        AppIconsKeys.readLater,
                        width: 16,
                        // color: AppTheme.keyAppColor,
                        colorFilter: controller.book.planingBook != null &&
                                controller.book.planingBook!.id == 2
                            ? const ColorFilter.mode(
                                AppTheme.keyAppColor,
                                BlendMode.srcIn,
                              )
                            : null,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () async {
                        controller.book.planingBook = listPlaningBooks[2];
                        await HiveDataStore().updateBook(book: controller.book);
                        controller.update();
                      },
                      child: SvgPicture.asset(
                        AppIconsKeys.readed,
                        width: 16,
                        colorFilter: controller.book.planingBook != null &&
                                controller.book.planingBook!.id == 3
                            ? const ColorFilter.mode(
                                AppTheme.keyAppColor,
                                BlendMode.srcIn,
                              )
                            : null,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {
                        PlaningBottomSheet.show(book: controller.book);
                      },
                      child: SvgPicture.asset(
                        AppIconsKeys.addCollection,
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {
                        /// Share File
                        shareFile(controller.pdfFile!.path, controller.book.title!);
                      },
                      child: SvgPicture.asset(
                        AppIconsKeys.share,
                        width: 16,
                      ),
                    ),
                    const ContainerDivider(margin: EdgeInsetsDirectional.only(start: 12)),
                    DeleteOneBookWidget(book: controller.book),
                  ],
                ),

                const SizedBox(height: 35),

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
                const SizedBox(height: 30),
                Expanded(
                  child: ValueListenableBuilder<Box<Map<dynamic, dynamic>>>(
                      valueListenable: HiveDataStore().booksListenable(),
                      builder: (_, Box<Map<dynamic, dynamic>> box, __) {
                        final List<Map<dynamic, dynamic>> books = box.values.toList();

                        miraiPrint('Map<dynamic, dynamic>> $books');

                        Book book = Book();
                        for (Map<dynamic, dynamic> bookJson in books) {
                          if (Book.fromJson(bookJson) == controller.book) {
                            book = Book.fromJson(bookJson);
                            break;
                          }
                        }

                        //   final Book book = Book.fromJson(bookJson);
                        return TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            if (book.notes!.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                //  physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: book.notes!.length,
                                itemBuilder: (_, int index) {
                                  return TextWidget(
                                    text: book.notes![index],
                                  );
                                },
                              )
                            else
                              const Center(child: Text('No Data')),
                            if (book.quotes!.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                //   physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: book.quotes!.length,
                                itemBuilder: (_, int index) {
                                  return TextWidget(
                                    text: book.quotes![index],
                                  );
                                },
                              )
                            else
                              const Center(child: Text('No Data')),
                          ],
                        );
                      }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

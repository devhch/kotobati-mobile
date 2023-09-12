import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/note_model.dart';
import 'package:kotobati/app/core/models/quote_model.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/book_details/views/components/text_widget.dart';
import 'package:kotobati/app/modules/navigation/controllers/navigation_controller.dart';
import 'package:kotobati/app/modules/reading/views/components/book_widget.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';
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
                        color:
                            _tabController.index == 0 ? AppTheme.keyAppColor : Colors.transparent,
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
                        color:
                            _tabController.index == 1 ? AppTheme.keyAppColor : Colors.transparent,
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
            child: ValueListenableBuilder<Box<Map<dynamic, dynamic>>>(
              valueListenable: HiveDataStore().booksListenable(),
              builder: (_, Box<Map<dynamic, dynamic>> box, __) {
                final List<Map<dynamic, dynamic>> books = box.values.toList();
                List<Note> notes = <Note>[];
                List<Quote> quotes = <Quote>[];

                for (Map<dynamic, dynamic> bookJson in books) {
                  Book book = Book.fromJson(bookJson);
                  for (Note note in book.notes!) {
                    note.book = book;
                    notes.add(note);
                  }

                  for (Quote quote in book.quotes!) {
                    quote.book = book;
                    quotes.add(quote);
                  }
                }

                return TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    if (notes.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        //  physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: notes.length,
                        itemBuilder: (_, int index) {
                          final Note note = notes[index];
                          return TextWidget(
                              book: note.book!,
                              title: '${note.book?.title}',
                              text: note.content,
                              page: note.page,
                              cover: note.book?.image

                              // cover: (note.book?.image != null && note.book!.image is String)
                              //     ? note.book!.image
                              //     : null,
                              );
                        },
                      )
                    else
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'لاتوجد بيانات',
                                style: context.textTheme.displayLarge!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'يرجى الذهاب إلى صفحة الكتب المنزلة \nوإضافة الملاحظات إلى بعض الكتب!',
                                style: context.textTheme.displayLarge!.copyWith(
                                  color: AppTheme.keyAppWhiteGrayColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),
                              MiraiElevatedButtonWidget(
                                onTap: () {
                                  Get.find<NavigationController>().setIndex(index: 1);
                                },
                                rounded: true,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                                overlayColor: Colors.white.withOpacity(.2),
                                child: Text(
                                  "اكتشف الكتب المتاحة",
                                  style: context.textTheme.displayLarge!.copyWith(
                                    color: AppTheme.keyAppBlackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (quotes.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: quotes.length,
                        itemBuilder: (_, int index) {
                          final Quote quote = quotes[index];
                          return TextWidget(
                            book: quote.book!,
                            title: quote.book!.title!,
                            image: quote.content,
                            page: quote.page,
                            cover: quote.book?.image,
                          );
                        },
                      )
                    else
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'لاتوجد بيانات',
                                style: context.textTheme.displayLarge!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'يرجى الذهاب إلى صفحة الكتب المنزلة \nوإضافة الإقتباسات إلى بعض الكتب!',
                                style: context.textTheme.displayLarge!.copyWith(
                                  color: AppTheme.keyAppWhiteGrayColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),
                              MiraiElevatedButtonWidget(
                                onTap: () {
                                  Get.find<NavigationController>().setIndex(index: 1);
                                },
                                rounded: true,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                                overlayColor: Colors.white.withOpacity(.2),
                                child: Text(
                                  "اكتشف الكتب المتاحة",
                                  style: context.textTheme.displayLarge!.copyWith(
                                    color: AppTheme.keyAppBlackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: MiraiSize.bottomNavBarHeight94),
        ],
      ),
    );
  }
}

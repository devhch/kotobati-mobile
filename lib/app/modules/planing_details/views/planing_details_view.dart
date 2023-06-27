import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/reading/views/components/book_widget.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';

import '../controllers/planing_details_controller.dart';

class PlaningDetailsView extends GetView<PlaningDetailsController> {
  const PlaningDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      backButton: true,
      child: ValueListenableBuilder<Box<Map<dynamic, dynamic>>>(
        valueListenable: HiveDataStore().booksListenable(),
        builder: (_, Box<Map<dynamic, dynamic>> box, __) {
          final List<Map<dynamic, dynamic>> books = box.values.toList();

          List<Book> castBooks = <Book>[];

          debugPrint("planingBooksModel: ${controller.planingBooksModel}");

          for (int i = 0; i < books.length; i++) {
            final Book book = Book.fromJson(books[i]);

            if (book.planingBook != null &&
                book.planingBook!.id == controller.planingBooksModel.id) {
              castBooks.add(Book.fromJson(books[i]));
            }
          }

          if (castBooks.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 90,
              ),
              itemCount: castBooks.length,
              itemBuilder: (_, int index) {
                return BookWidget(book: castBooks[index]);
              },
            );
          } else {
            return const Center(child: Text('No Data'));
          }
        },
      ),
    );
  }
}

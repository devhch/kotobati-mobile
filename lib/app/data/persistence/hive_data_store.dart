/*
* Created By Mirai Devs.
* On 25/6/2023.
*/

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotobati/app/core/models/book_model.dart';

import '../../core/helpers/common_function.dart';

class HiveDataStore {
  /// CategoryModel Box Name
  static String booksBoxName = 'books_box_key';

  /// init
  Future<void> init() async {
    await Hive.initFlutter();

    /// Open boxes Keys

    /// Books Box Name
    await Hive.openBox<Map<dynamic, dynamic>>(booksBoxName);
  }

  /// --------------------- Books ---------------------///
  Future<void> saveBook({required Book book}) async {
    final Box<Map<dynamic, dynamic>> bookBox =
        Hive.box<Map<dynamic, dynamic>>(booksBoxName);
  //  await bookBox.clear();
    await bookBox.add(book.toJson());
    if (kDebugMode) {
      print('\n<=------------------------------=>');
      print('saved book: ${book.toString()}\n');
      print('\n<=------------------------------=>');
    }
  }

  Future<void> setBooks({
    required List<Book> books,
    bool force = false,
  }) async {
    final Box<Map<dynamic, dynamic>> bookBox =
        Hive.box<Map<dynamic, dynamic>>(booksBoxName);
    await bookBox.clear();
    final List<Map<String, dynamic>> castedCategories =
        books.map((Book book) => book.toJson()).toList();
    await bookBox.addAll(castedCategories);
    miraiPrint('Books cast: ${books.cast()}');
    debugPrint('\n=> Saved Books: ${books.toString()}\n');
  }

  List<Book> getBooks() {
    final Box<Map<dynamic, dynamic>> booksBox =
        Hive.box<Map<dynamic, dynamic>>(booksBoxName);
    if (booksBox.isNotEmpty) {
      List<Book> books = booksBox.values
          .map((Map<dynamic, dynamic> offerMsp) => Book.fromJson(offerMsp))
          .toList();

      debugPrint('\n=> GetSaved Books: ${books.toString()}\n');
      return books;
    } else {
      return <Book>[];
    }
  }

  Future<void> clearBooks() async {
    final Box<Map<dynamic, dynamic>> categoryBox =
        Hive.box<Map<dynamic, dynamic>>(booksBoxName);
    await categoryBox.clear();
    debugPrint('\n=> Categories are Deleted.\n');
  }

  ValueListenable<Box<Map<dynamic, dynamic>>> booksListenable() {
    return Hive.box<Map<dynamic, dynamic>>(booksBoxName).listenable();
  }
}

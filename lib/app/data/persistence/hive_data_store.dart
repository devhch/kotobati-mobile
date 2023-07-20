/*
* Created By Mirai Devs.
* On 25/6/2023.
*/

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/models/setting_objects_model.dart';

import '../../core/helpers/common_function.dart';

class HiveDataStore {
  /// CategoryModel Box Name
  static String booksBoxName = 'books_box_key';
  static String planingBooksBoxName = 'planing_books_box_key';
  static String settingBoxName = 'setting_box_key';

  /// init
  Future<void> init() async {
    await Hive.initFlutter();

    /// Open boxes Keys

    /// Books Box Name
    await Hive.openBox<Map<dynamic, dynamic>>(booksBoxName);

    await Hive.openBox<Map<dynamic, dynamic>>(planingBooksBoxName);

    await Hive.openBox<Map<dynamic, dynamic>>(settingBoxName);
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
          .map((Map<dynamic, dynamic> bookMap) => Book.fromJson(bookMap))
          .toList();

      // debugPrint('\n=> GetSaved Books: ${books.toString()}\n');
      return books;
    } else {
      return <Book>[];
    }
  }

  Future<bool> deleteBook({required Book book}) async {
    final Box<Map<dynamic, dynamic>> bookBox =
        Hive.box<Map<dynamic, dynamic>>(booksBoxName);
    if (bookBox.isNotEmpty) {
      miraiPrint('\n=> BookBox isNotEmpty\n');
      miraiPrint('\n=> Deleting this BooK ${book.toString()}\n');
      final int index = bookBox.values.toList().indexWhere(
            (Map<dynamic, dynamic> bookAtIndex) => Book.fromJson(bookAtIndex).title == book.title && Book.fromJson(bookAtIndex).image == book.image,
          );
      miraiPrint('\n=> BookBox $index\n');
      if (index >= 0) {
        await bookBox.deleteAt(index);
        miraiPrint('\n=> Delete This Book: ${book.toString()}\n');
        return true;
      }
    }
    return false;
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

  Future<bool> updateBook({required Book book}) async {
    final Box<Map<dynamic, dynamic>> bookBox =
        Hive.box<Map<dynamic, dynamic>>(booksBoxName);

    List<Book> books =
        getBooks().where((Book element) => element.path != book.path).toList();

    books.add(book);

    final List<Map<String, dynamic>> castedCategories =
        books.map((Book book) => book.toJson()).toList();

    // miraiPrint('Books : ${books.toString()}');
    // miraiPrint('Books: ${castedCategories.toList().toString()}');

    await bookBox.clear();
    await bookBox.addAll(castedCategories);

    debugPrint('\n=> Saved Books: ${books.toString()}\n');
    return true;
  }

  Future<void> savePlaningBook({
    required List<PlaningBooksModel> planingBooks,
  }) async {
    final Box<Map<dynamic, dynamic>> bookBox =
        Hive.box<Map<dynamic, dynamic>>(planingBooksBoxName);

    await bookBox.clear();

    final List<Map<String, dynamic>> castedCategories =
        planingBooks.map((PlaningBooksModel book) => book.toJson()).toList();

    await bookBox.addAll(castedCategories);

    miraiPrint('Books cast: ${planingBooks.cast()}');
    debugPrint('\n=> Saved Books: ${planingBooks.toString()}\n');
  }

  List<PlaningBooksModel> getPlaningBooks() {
    final Box<Map<dynamic, dynamic>> booksBox =
        Hive.box<Map<dynamic, dynamic>>(planingBooksBoxName);

    if (booksBox.isNotEmpty) {
      List<PlaningBooksModel> books = booksBox.values
          .map((Map<dynamic, dynamic> offerMsp) => PlaningBooksModel.fromJson(offerMsp))
          .toList();

      debugPrint('\n=> GetSaved Books: ${books.toString()}\n');
      return books;
    } else {
      return <PlaningBooksModel>[];
    }
  }

  Future<SettingObjectsModel> getSettingObjects() async {
    final Box<Map<dynamic, dynamic>> settingBox =
        Hive.box<Map<dynamic, dynamic>>(settingBoxName);

    SettingObjectsModel setting = SettingObjectsModel();

    if (settingBox.isNotEmpty) {
      setting = SettingObjectsModel.fromJson(settingBox.values.first);
    }

    debugPrint("settingObject: $setting");

    return setting;
  }

  Future<SettingObjectsModel> saveSettingObjects({
    required SettingObjectsModel settingObjectsModel,
  }) async {
    final Box<Map<dynamic, dynamic>> settingBox =
        Hive.box<Map<dynamic, dynamic>>(settingBoxName);

    await settingBox.clear();

    await settingBox.add(settingObjectsModel.toJson());

    await getSettingObjects();

    return settingObjectsModel;
  }
}

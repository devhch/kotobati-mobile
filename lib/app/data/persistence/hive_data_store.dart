/*
* Created By Mirai Devs.
* On 25/6/2023.
*/

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/mirai_pdf_model.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/models/setting_objects_model.dart';

import '../../core/helpers/common_function.dart';

class HiveDataStore {
  /// Keys Box Name
  static String booksBoxName = 'books_box_key';
  static String planingBooksBoxName = 'planing_books_box_key';
  static String settingBoxName = 'setting_box_key';
  static String searchHistoryBoxName = 'search_history_box_key';
  static const String keysBoxName = 'keys_box_name';
  static const String pdfFilesBoxName = 'pdf_files_box_name';

  /// Intro
  static String introKey = 'intro_key';

  /// init
  Future<void> init() async {
    await Hive.initFlutter();

    /// Open boxes Keys

    /// Books Box Name
    await Hive.openBox<Map<dynamic, dynamic>>(booksBoxName);

    await Hive.openBox<Map<dynamic, dynamic>>(planingBooksBoxName);

    await Hive.openBox<Map<dynamic, dynamic>>(settingBoxName);
    await Hive.openBox<Map<dynamic, dynamic>>(pdfFilesBoxName);

    await Hive.openBox<String>(searchHistoryBoxName);
    await Hive.openBox<String>(keysBoxName);
  }

  /// --------------------- Books ---------------------///
  Future<void> saveBook({required Book book}) async {
    final Box<Map<dynamic, dynamic>> bookBox = Hive.box<Map<dynamic, dynamic>>(booksBoxName);
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
    final Box<Map<dynamic, dynamic>> bookBox = Hive.box<Map<dynamic, dynamic>>(booksBoxName);
    await bookBox.clear();
    final List<Map<String, dynamic>> castedCategories =
        books.map((Book book) => book.toJson()).toList();
    await bookBox.addAll(castedCategories);
    miraiPrint('Books cast: ${books.cast()}');
    debugPrint('\n=> Saved Books: ${books.toString()}\n');
  }

  List<Book> getBooks() {
    final Box<Map<dynamic, dynamic>> booksBox = Hive.box<Map<dynamic, dynamic>>(booksBoxName);
    if (booksBox.isNotEmpty) {
      List<Book> books =
          booksBox.values.map((Map<dynamic, dynamic> bookMap) => Book.fromJson(bookMap)).toList();

      // debugPrint('\n=> GetSaved Books: ${books.toString()}\n');
      return books;
    } else {
      return <Book>[];
    }
  }

  Future<bool> deleteBook({required Book book}) async {
    final Box<Map<dynamic, dynamic>> bookBox = Hive.box<Map<dynamic, dynamic>>(booksBoxName);
    if (bookBox.isNotEmpty) {
      miraiPrint('\n=> BookBox isNotEmpty\n');
      miraiPrint('\n=> Deleting this BooK ${book.toString()}\n');
      final int index = bookBox.values.toList().indexWhere(
            (Map<dynamic, dynamic> bookAtIndex) =>
                Book.fromJson(bookAtIndex).title == book.title &&
                Book.fromJson(bookAtIndex).id == book.id,
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
    final Box<Map<dynamic, dynamic>> categoryBox = Hive.box<Map<dynamic, dynamic>>(booksBoxName);
    await categoryBox.clear();
    debugPrint('\n=> Categories are Deleted.\n');
  }

  ValueListenable<Box<Map<dynamic, dynamic>>> booksListenable() {
    return Hive.box<Map<dynamic, dynamic>>(booksBoxName).listenable();
  }

  Future<bool> updateBook({required Book book}) async {
    final Box<Map<dynamic, dynamic>> bookBox = Hive.box<Map<dynamic, dynamic>>(booksBoxName);

    final List<Map<dynamic, dynamic>> list = bookBox.values.toList();

    /// Check if this book is exists in DB...
    bool isExists = false;
    for (Map<dynamic, dynamic> jsonItem in list) {
      if (jsonItem['id'] == book.id && jsonItem['path'] == book.path) {
        isExists = true;
        break;
      }
    }

    if (isExists) {
      int index = 0;
      for (int i = 0; i < list.length; i++) {
        if (list[i]['path'] == book.toJson()['path']) {
          index = i;
          break;
        }
      }
      miraiPrint('updateBook at $index');
      await bookBox.putAt(index, book.toJson());
    } else {
      await bookBox.add(book.toJson());
    }

    debugPrint('\n=> Saved Books: ${book.toString()}\n');
    return true;
  }

  Future<void> savePlaningBook({
    required List<PlaningBooksModel> planingBooks,
  }) async {
    final Box<Map<dynamic, dynamic>> bookBox = Hive.box<Map<dynamic, dynamic>>(planingBooksBoxName);

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
    final Box<Map<dynamic, dynamic>> settingBox = Hive.box<Map<dynamic, dynamic>>(settingBoxName);

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
    final Box<Map<dynamic, dynamic>> settingBox = Hive.box<Map<dynamic, dynamic>>(settingBoxName);

    await settingBox.clear();

    await settingBox.add(settingObjectsModel.toJson());

    // await getSettingObjects();

    return settingObjectsModel;
  }

  /// --------------------- Search History ---------------------///
  Future<void> saveSearchHistory({required String query}) async {
    final Box<String> searchBox = Hive.box<String>(searchHistoryBoxName);
    await searchBox.add(query);
    if (kDebugMode) {
      print('\n<=------------------------------=>');
      print('Save Search History: $query\n');
      print('\n<=------------------------------=>');
    }
  }

  List<String> getSearchHistory() {
    final Box<String> booksBox = Hive.box<String>(searchHistoryBoxName);

    if (booksBox.isNotEmpty) {
      List<String> books = booksBox.values.toList();

      debugPrint('\n=> GetSaved Books: ${books.toString()}\n');
      return books;
    } else {
      return <String>[];
    }
  }

  ValueListenable<Box<String>> searchHistoryListenable() {
    return Hive.box<String>(searchHistoryBoxName).listenable();
  }

  /// -------------------------- Save Intro --------------------------///

  Future<void> saveIntroSeenState({required bool isSeen}) async {
    // keysBoxName
    Box<String> box = Hive.box<String>(keysBoxName);
    await box.put(introKey, isSeen.toString());
    String saveIntroIsSeen = box.get(introKey) ?? 'false';
    debugPrint('saved intro seen: $saveIntroIsSeen');
  }

  bool getIntroSeenState() {
    // keysBoxName
    Box<String> box = Hive.box<String>(keysBoxName);
    String saveIntroIsSeen = box.get(introKey) ?? "false";

    debugPrint('saved intro is seen: $saveIntroIsSeen');

    return (saveIntroIsSeen == "true");
  }

  /// ----------------------------------------------------///

  /// --------------------- Mirai PDFs ---------------------///
  Future<void> saveMiraiPDF({required MiraiPDF miraiPDF}) async {
    final Box<Map<dynamic, dynamic>> miraiPDFBox = Hive.box<Map<dynamic, dynamic>>(pdfFilesBoxName);
    await miraiPDFBox.add(miraiPDF.toJson());
    if (kDebugMode) {
      print('\n<=------------------------------=>');
      print('Saved MiraiPDF: ${miraiPDF.toString()}\n');
      print('\n<=------------------------------=>');
    }
  }

  Future<void> setMiraiPDFs({
    required List<MiraiPDF> miraiPDFs,
    bool force = false,
  }) async {
    final Box<Map<dynamic, dynamic>> miraiPDFBox = Hive.box<Map<dynamic, dynamic>>(pdfFilesBoxName);
    final List<Map<String, dynamic>> castedCategories =
        miraiPDFs.map((MiraiPDF miraiPDF) => miraiPDF.toJson()).toList();
    miraiPDFs.clear();
    await miraiPDFBox.addAll(castedCategories);
    log('MiraiPDFs cast: ${miraiPDFs.cast()}');
    miraiPrint('========================================');
    log('\n=> Saved MiraiPDFs: ${miraiPDFs.toString()}\n');
  }

  List<MiraiPDF> getMiraiPDfs() {
    final Box<Map<dynamic, dynamic>> miraiPDFBox = Hive.box<Map<dynamic, dynamic>>(pdfFilesBoxName);
    if (miraiPDFBox.isNotEmpty) {
      List<MiraiPDF> miriaPDFs = miraiPDFBox.values
          .map((Map<dynamic, dynamic> pdfMap) => MiraiPDF.fromJson(pdfMap))
          .toList();
      miraiPrint('<= getMiraiPDfs: ${miriaPDFs.length} =======================================');
      return miriaPDFs;
    } else {
      return <MiraiPDF>[];
    }
  }

  Future<bool> deleteMirai({required MiraiPDF miraiPDF}) async {
    final Box<Map<dynamic, dynamic>> miraiPDFBox = Hive.box<Map<dynamic, dynamic>>(pdfFilesBoxName);
    if (miraiPDFBox.isNotEmpty) {
      miraiPrint('\n=> MiraiPDFBoxBox isNotEmpty\n');
      miraiPrint('\n=> Deleting this miraiPDF ${miraiPDF.toString()}\n');
      final int index = miraiPDFBox.values.toList().indexWhere(
            (Map<dynamic, dynamic> bookAtIndex) =>
                Book.fromJson(bookAtIndex).title == miraiPDF.title &&
                Book.fromJson(bookAtIndex).image == miraiPDF.image,
          );
      miraiPrint('\n=> MiraiPDFBox $index\n');
      if (index >= 0) {
        await miraiPDFBox.deleteAt(index);
        miraiPrint('\n=> Delete This MiraPDF: ${miraiPDF.toString()}\n');
        return true;
      }
    }
    return false;
  }

  Future<void> clearMiraiPDFs() async {
    final Box<Map<dynamic, dynamic>> miraiPDFBox = Hive.box<Map<dynamic, dynamic>>(pdfFilesBoxName);
    await miraiPDFBox.clear();
    debugPrint('\n=> MiraiPDFs are Deleted.\n');
  }

  ValueListenable<Box<Map<dynamic, dynamic>>> miraiPDFsListenable() {
    return Hive.box<Map<dynamic, dynamic>>(pdfFilesBoxName).listenable();
  }

  /// ----------------------------------------------------///
}

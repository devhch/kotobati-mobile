import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/mirai_pdf_model.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdfx/pdfx.dart'; // Import the collection package

import 'package:intl/intl.dart' as intl;
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/app_custom_dialog.dart';

class SearchPDFController extends GetxController {
  // Call the native method to get PDF files and wait for the result
  static const MethodChannel platform = MethodChannel('com.kotobati.pdf_reader_channel');

  List<MiraiPDF> pdfPaths = <MiraiPDF>[];

  /// Lists
  ValueNotifier<List<MiraiPDF>> pdfFilesForSearch = ValueNotifier<List<MiraiPDF>>(<MiraiPDF>[]);

  bool isDoneSearching = false;
  bool isPDFsFromHive = false;

  ValueNotifier<int> downloadProgress = ValueNotifier<int>(0);
  int total = 1;

  @override
  void onReady() {
    super.onReady();
    miraiPrint('SearchControllerC onReady');
    check();
  }

  Future<void> check() async {
    final List<MiraiPDF> miraiPDFs = HiveDataStore().getMiraiPDfs();
    if (miraiPDFs.isNotEmpty) {
      await Future<void>.delayed(const Duration(seconds: 1), () {});
      log('miraiPDFs ${miraiPDFs.toString()}');
      isPDFsFromHive = true;
      // pdfPaths = miraiPDFs;
      total = miraiPDFs.length;
      pdfPaths = miraiPDFs;
      pdfFilesForSearch.value = List<MiraiPDF>.from(pdfPaths);

      isDoneSearching = true;

      /// Update...
      update();
      //  await loadFileImageAndSize(miraiPDFs);
    } else {
      await getPdfFilesFromNative();
    }
  }

  void search(String query) {
    final String normalizedSearchText = Intl.canonicalizedLocale(query);
    final RegExp regex = RegExp(normalizedSearchText, caseSensitive: false, unicode: true);

    /// Search in categories
    pdfFilesForSearch.value = pdfPaths.where((MiraiPDF pdfWidthImage) {
      final String normalizedText = Intl.canonicalizedLocale(pdfWidthImage.title.toLowerCase());
      return regex.hasMatch(normalizedText);
    }).toList();
    pdfFilesForSearch.notifyListeners();
  }

  // Native method call using MethodChannel to get PDF files from native code
  Future<void> getPdfFilesFromNative() async {
    miraiPrint('getPdfFilesFromNative  Called');
    if (pdfPaths.isEmpty) {
      miraiPrint('getPdfFilesFromNative  pdfPaths.isEmpty');

      bool permissionGranted = false;
      final bool hasManageExternalStoragePermission = await checkManageExternalStoragePermission();
      miraiPrint('checkManageExternalStoragePermission  $hasManageExternalStoragePermission');
      permissionGranted = hasManageExternalStoragePermission;
      if (!hasManageExternalStoragePermission) {
        AppMiraiDialog.snackBarError(
          title: 'تم رفض الوصول إلى إذن الملفات!',
          message:
              'يرجى السماح بإذن الوصول إلى الملفات للحصول على جميع ملفات pdf من الجهاز ...\n"Allow access to manage all files"',
          duration: 4,
        );

        await Future<void>.delayed(const Duration(seconds: 4), () {});

        try {
          /// Request read external storage permission
          miraiPrint(' Request read external storage permission');
          permissionGranted = await requestManageExternalStoragePermission();
          miraiPrint(' permissionGranted $permissionGranted');
          // await getPdfFilesFromNative();
        } on PlatformException catch (e) {
          miraiPrint("Error: ${e.message}");
        }
      }

      try {
        if (permissionGranted) {
          /// Call the native method to get PDF files and wait for the result
          final List<dynamic> pdfFiles = await platform.invokeMethod('getPdfFilesFromNative');
          List<String> pdfPathsAsString = pdfFiles.cast<String>();
          total = pdfPathsAsString.length;
          // ..sort((String a, String b) => a.toLowerCase().compareTo(b.toLowerCase()));
          // Sort the list alphabetically using Unicode code points
          pdfPathsAsString.sort((String a, String b) =>
              Intl.canonicalizedLocale(a).compareTo(Intl.canonicalizedLocale(b)));
          miraiPrint('pdfPaths $pdfPathsAsString');

          /// Update...
          update();

          await loadFileImageAndSize(pdfPathsAsString);

          if (pdfFilesForSearch.value.isNotEmpty) {
            /// Save To HIVE
            HiveDataStore().setMiraiPDFs(miraiPDFs: pdfFilesForSearch.value);
          }
        } else {
          miraiPrint("Permission not granted.");
          AppMiraiDialog.snackBarError(
            title: 'تم رفض الوصول إلى إذن الملفات!',
            message: 'يرجى السماح بإذن الوصول إلى الملفات للحصول على جميع ملفات pdf من الجهاز ...',
            duration: 4,
          );
          openAppSettings();
        }
      } on PlatformException catch (e) {
        miraiPrint("Error: ${e.message}");
      }
    }
  }

  Future<void> loadFileImageAndSize(List<String> pdfPathsAsString) async {
    pdfPaths.clear();
    for (String pdfPath in pdfPathsAsString) {
      final String title = pdfPath
          .split('/')
          .last
          .capitalizeFirst!
          .replaceAll('-', ' ')
          .replaceAll('pdf', ' ')
          .replaceAll('.pdf', '')
          .trim();
      MiraiPDF pdfWidthImage = MiraiPDF(title: title, path: pdfPath);

      final String size = await getFileSizes(pdfPath, 2);
      debugPrint('size $size');
      pdfWidthImage.size = size;

      pdfWidthImage.image = await generatePdfCover(pdfPath);

      pdfPaths.add(pdfWidthImage);

      downloadProgress.value += 1;

      await Future<void>.delayed(const Duration(milliseconds: 50), () {});
    }

    pdfFilesForSearch.value = pdfPaths;

    isDoneSearching = true;

    update();
  }

  Future<bool> checkManageExternalStoragePermission() async {
    bool hasPermission;
    try {
      hasPermission = await platform.invokeMethod('hasManageExternalStoragePermission');
    } on PlatformException catch (e) {
      hasPermission = false; // Handle exception, if any
    }

    return hasPermission;
  }

  /// Native method call using MethodChannel to request read external storage permission
  Future<bool> requestManageExternalStoragePermission() async {
    try {
      final bool permissionGranted =
          await platform.invokeMethod('requestManageExternalStoragePermission');
      return permissionGranted;
    } catch (e) {
      throw PlatformException(code: 'ERROR', message: 'Failed to communicate with native code');
    }
  }

  Future<String> getFileSizes(String filepath, int decimals) async {
    File file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";

    const List<String> suffixes = <String>["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    int i = (math.log(bytes) / math.log(1024)).floor();
    double size = bytes / math.pow(1024, i);

    // Using NumberFormat for consistent and accurate formatting
    intl.NumberFormat format = intl.NumberFormat.decimalPattern();
    String formattedSize = format.format(size);

    return '$formattedSize ${suffixes[i]}';
  }

  Future<Uint8List> generatePdfCover(String path) async {
    final PdfDocument pdfRenderer = await PdfDocument.openFile(path);
    final PdfPage page = await pdfRenderer.getPage(1); // Get the first page as the cover

    // Adjust the dimensions according to your cover requirements
    const double width = 200;
    const double height = 300;

    final PdfPageImage? pageImage = await page.render(width: width, height: height);
    final Uint8List imageData = pageImage!.bytes;

    page.close();
    pdfRenderer.close();

    return imageData;
  }

  Future<String> saveFileToDevice(String fileName, List<int> bytes) async {
    try {
      final String path = await createFolder();

      String filename = fileName.replaceAll('.pdf', '');
      miraiPrint('saveFileToDevice filename $filename');

      String filePath = '$path/$filename';
      miraiPrint('saveFileToDevice to filePath $filePath');

      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Optionally, you can show a success message here
      miraiPrint('File saved successfully: $filePath');
      return filePath;
    } catch (e) {
      // Handle any errors that may occur during file saving
      miraiPrint('Error saving file: $e');
      return '';
    }
  }

  Future<List<int>> readFileBytes(String path) async {
    try {
      File file = File(path);
      List<int> bytes = await file.readAsBytes();
      return bytes;
    } catch (e) {
      miraiPrint('Error reading file: $e');
      return <int>[];
    }
  }
}

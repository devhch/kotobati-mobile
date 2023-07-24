import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdfx/pdfx.dart'; // Import the collection package

import 'package:intl/intl.dart' as intl;

class SearchControllerC extends GetxController {
  late final TextEditingController txtController;

  List<PdfWidthImage> pdfPaths = <PdfWidthImage>[];

  /// Lists
  ValueNotifier<List<PdfWidthImage>> pdfFilesForSearch =
      ValueNotifier<List<PdfWidthImage>>(<PdfWidthImage>[]);

  @override
  void onInit() {
    txtController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getPdfFilesFromNative();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  void search(String query) {
    final String normalizedSearchText = Intl.canonicalizedLocale(query);
    final RegExp regex = RegExp(normalizedSearchText, caseSensitive: false, unicode: true);

    /// Search in categories
    pdfFilesForSearch.value = pdfPaths.where((PdfWidthImage pdfWidthImage) {
      final String normalizedText = Intl.canonicalizedLocale(pdfWidthImage.title.toLowerCase());
      return regex.hasMatch(normalizedText);
    }).toList();
  }

  // Native method call using MethodChannel to get PDF files from native code
  Future<void> getPdfFilesFromNative() async {
    if (pdfPaths.isEmpty) {
      // Call the native method to get PDF files and wait for the result
      const MethodChannel platform = MethodChannel('com.kotobati.pdf_reader_channel');
      try {
        final List<dynamic> pdfFiles = await platform.invokeMethod('getPdfFilesFromNative');
        List<String> pdfPathsAsString = pdfFiles.cast<String>()
          ..sort((String a, String b) => a.toLowerCase().compareTo(b.toLowerCase()));
        miraiPrint('pdfPaths $pdfPaths');

        for (String pdfPath in pdfPathsAsString) {
          final String title = pdfPath
              .split('/')
              .last
              .capitalizeFirst!
              .replaceAll('-', ' ')
              .replaceAll('pdf', ' ')
              .replaceAll('.pdf', '')
              .trim();
          PdfWidthImage pdfWidthImage = PdfWidthImage(title: title, path: pdfPath);

          final String size = await getFileSizes(pdfPath, 2);
          debugPrint('size $size');
          pdfWidthImage.size = size;

          pdfWidthImage.image?.value = await generatePdfCover(pdfPath);

          // pdfPageImage;

          pdfPaths.add(pdfWidthImage);
        }

        pdfFilesForSearch.value = pdfPaths;

        update();
      } catch (e) {
        throw PlatformException(code: 'ERROR', message: 'Failed to communicate with native code');
      }
    }
  }

  Future<String> getFileSizes(String filepath, int decimals) async {
    File file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";

    const List<String> suffixes = <String>["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    int i = (log(bytes) / log(1024)).floor();
    double size = bytes / pow(1024, i);

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

class PdfWidthImage {
  final String title;
  final String path;
  String size;
  ValueNotifier<Uint8List?>? image;

  PdfWidthImage({
    this.title = '',
    this.path = '',
    this.size = '',
    this.image,
  }) {
    image ??= ValueNotifier<Uint8List?>(null);
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:croppy/croppy.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:get/get.dart';

import 'dart:ui' as ui;

import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/quote_model.dart';
import 'package:kotobati/app/core/models/setting_objects_model.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/pdf_reader/views/components/crop_image_widget.dart';
import 'package:kotobati/app/widgets/mirai_verifying_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PdfReaderController extends GetxController {
  String pdfPath = '';
  ValueNotifier<Book?> book = ValueNotifier<Book?>(null);
  ValueNotifier<int?> goToPage = ValueNotifier<int?>(null);

  final HiveDataStore hive = HiveDataStore();
  ScreenBrightness screenBrightness = ScreenBrightness();

  PDFViewController? pdfViewerController;

  File? pdfFile;

  /// Saved Page
  late ValueNotifier<(int, int)> savedPage;

  late ValueNotifier<bool> fullScreen;
  late ValueNotifier<bool> isPdfLoaded;
  late ValueNotifier<bool> isPaddingChanging;
  late ValueNotifier<double> pagePadding;

  late ValueNotifier<bool> isScrolling;

  late ValueNotifier<bool> isExpandedOptions;

  late ScrollController scrollController;

  late ScreenshotController screenshotController;

  bool isVertical = true;
  bool isDarkMode = false;

  ///
  ValueNotifier<double> brightness = ValueNotifier<double>(0.5);
  double defaultBrightness = 0.0;
  double colorTemperature = 3000;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onReady() {
    super.onReady();
    update();
  }

  @override
  void dispose() {
    miraiPrint("PdfReaderController dispose");
    pdfPath = '';
    pdfFile = null;
    pdfViewerController = null;
    // book.value = null;
    // book.dispose();
    savedPage.dispose();
    fullScreen.dispose();
    isPdfLoaded.dispose();
    isPaddingChanging.dispose();
    isScrolling.dispose();
    isExpandedOptions.dispose();
    pagePadding.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    miraiPrint('<=================>>');
    miraiPrint('Book: ${book.value}');
    miraiPrint('<=================>>');
    close();
    super.onClose();
  }

  Future<void> init() async {
    savedPage = ValueNotifier<(int, int)>((0, 0));
    fullScreen = ValueNotifier<bool>(false);
    isPdfLoaded = ValueNotifier<bool>(false);
    isPaddingChanging = ValueNotifier<bool>(true);
    isScrolling = ValueNotifier<bool>(false);
    isExpandedOptions = ValueNotifier<bool>(false);
    scrollController = ScrollController();
    pagePadding = ValueNotifier<double>(0);
    screenshotController = ScreenshotController();

    SettingObjectsModel setting = await hive.getSettingObjects();
    setReadingMode(setting.brightness);

    isVertical = !setting.horizontal;
    isDarkMode = setting.darkMode;
    pagePadding.value = setting.spacing;
    Map<String, dynamic> arguments = Get.arguments;
    book.value = arguments['book'];
    goToPage.value = arguments['page'];
    miraiPrint('<=================>>');
    miraiPrint('GoToPage: ${goToPage.value}');
    miraiPrint('<=================>>');

    miraiPrint('<=================>>');
    miraiPrint('Book: ${book.value}');
    miraiPrint('<=================>>');
    pdfPath = book.value!.path!;

    if (pdfPath.contains('Kotobati/')) {
      pdfPath = pdfPath.replaceAll('.pdf', '');
    }

    miraiPrint('PdfReaderController pdfPath: $pdfPath');
    pdfFile = File(pdfPath); // .replaceAll('.pdf', '')
    miraiPrint('File Path: $pdfPath');
    miraiPrint('File Exists: ${pdfFile?.existsSync()}');

    defaultBrightness = await systemBrightness;
    miraiPrint('defaultBrightness $defaultBrightness');

    // The following line will enable the Android and iOS wakelock.
    WakelockPlus.enable();

    bool isOn = await WakelockPlus.enabled;
    if (isOn) {
      miraiPrint("Screen is on stay awake mode");
    } else {
      miraiPrint("Screen is not on stay awake mode.");
    }
  }

  Future<void> close() async {
    if (defaultBrightness != 0) {
      //screenBrightness.setScreenBrightness(defaultBrightness);
      resetBrightness();
    }

    /// closes overlay if open
    // FlutterOverlayWindow.closeOverlay().then((bool? value) => log('STOPPED: value: $value'));

    // The next line disables the wakelock again.
    WakelockPlus.disable();
  }

  void setReadingMode(double bright) async {
    brightness.value = bright;
    await setBrightness(bright);
    // screenBrightness.setScreenBrightness(bright);
  }

  Future<void> takeQuote(BuildContext context) async {
    /// Capture and save to a file

    AppMiraiDialog.miraiDialogBar();

    miraiPrint('<==========================>');
    miraiPrint('takeQuote: capture');
    Uint8List? imageData = await screenshotController.capture();

    if (imageData != null) {
      miraiPrint('<==========================>');
      miraiPrint('takeQuote: imageData != null');
      miraiPrint('<==========================>');
      //   File.fromRawPath(imageData);
      File imageFile =
          await uint8ListToFile(imageData, 'captured_image${book.value?.id}${savedPage.value.$1}');
      miraiPrint('<==========================>');
      miraiPrint('takeQuote: uint8ListToFile');
      miraiPrint('<==========================>');

      Get.back();

      // CroppedFile? croppedImage = await cropSquareImage(imageFile.path);
      // File? croppedImage = await Get.to(()=> CropImageWidget(file: imageFile));
      final CropImageResult? croppedImageResult = await showCupertinoImageCropper(
        context,
        imageProvider: FileImage(imageFile),
      );

      final ByteData? data = await croppedImageResult?.uiImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      final Uint8List bytes = data!.buffer.asUint8List();
      File croppedImage = await uint8ListToFile(
        bytes,
        'captured_image_second${savedPage.value.$1}${book.value?.id}',
      );

      croppedImage = await croppedImage.writeAsBytes(bytes, flush: true);

      miraiPrint('<==========================>');
      miraiPrint('takeQuote: croppedImage $croppedImage');
      miraiPrint('<==========================>');

      // if (croppedImage != null) {
      miraiPrint('<=================================>');
      debugPrint('------------ crop true ------------');
      miraiPrint('<=================================>');
      if (croppedImage.path.isNotEmpty) {
        final String size = await getFileSize(croppedImage.path, 2);
        debugPrint('size $size');

        calculateImageDimension(File(croppedImage.path)).then(
          (Size size) => miraiPrint(
            "image size: width * height = ${size.width} * ${size.height}",
          ),
        );
        //   imageFile = File(croppedImage.path);

        final Uint8List croppedImageBytes = croppedImage.readAsBytesSync();

        /// Save Cropped Image to book
        final Quote quote =
            Quote.create(content: base64Encode(croppedImageBytes), page: savedPage.value.$1);
        miraiPrint('<=======================>');
        miraiPrint('Quote ${quote.toString()}');
        miraiPrint('<=======================>');
        book.value?.quotes?.add(quote);

        await HiveDataStore().updateBook(book: book.value!);

        croppedImage.deleteSync();
        imageFile.deleteSync();

        AppMiraiDialog.snackBar(
          duration: 4,
          backgroundColor: Colors.green,
          title: 'عظيم',
          message: 'تمت إضافة إقتباس إلى ${book.value?.title?.replaceAll('pdf', '')} ',
        );
      } else {
        miraiPrint('<==========================>');
        debugPrint('croppedImage.path isEmpty');
        miraiPrint('<==========================>');
      }
      // } else {
      //   miraiPrint('<==========================>');
      //   debugPrint('crop false');
      //   miraiPrint('<==========================>');
      //   // imageFile;
      //
      //   AppMiraiDialog.snackBarError(
      //     duration: 4,
      //     title: 'إنتباه!',
      //     message: 'لم يتمر إضافة اي إقتباس إلى ${book.value?.title?.replaceAll('pdf', '')} ',
      //   );
      // }

      miraiPrint('<==============================>');
      miraiPrint('takeQuote: imageData != null end');
      miraiPrint('<==============================>');
    } else {
      miraiPrint('takeQuote: imageData == null');
    }
    miraiPrint('<==========================>');
    debugPrint('End takeQuote');
    miraiPrint('<==========================>');
  }

  void enterFullScreen() {
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: <SystemUiOverlay>[]);
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  Future<double> get systemBrightness async {
    try {
      return await screenBrightness.system;
    } catch (e) {
      miraiPrint(e);
      // throw 'Failed to get system brightness';
      return Future<double>.value(0.0);
    }
  }

  Future<double> get currentBrightness async {
    try {
      return await screenBrightness.current;
    } catch (e) {
      miraiPrint(e);
      // throw 'Failed to get current brightness';
      return Future<double>.value(0.0);
    }
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await screenBrightness.setScreenBrightness(brightness);
    } catch (e) {
      miraiPrint(e);
      //throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await screenBrightness.resetScreenBrightness();
    } catch (e) {
      miraiPrint(e);
      // throw 'Failed to reset brightness';
    }
  }
}

void checkNotes(List<String> notes) {
  List<String> checkedList = <String>[
    """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
    """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
    "tttttt tttttt tttttt tttttt tttttt tttttt tttttt",
  ];

  for (String item in checkedList) {
    if (notes.contains(item)) {
      notes.remove(item);
    }
  }
}

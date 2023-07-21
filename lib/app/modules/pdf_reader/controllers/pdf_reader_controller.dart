import 'dart:developer';
import 'dart:io';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/models/setting_objects_model.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:screenshot/screenshot.dart';

class PdfReaderController extends GetxController {
  String pdfPath = '';
  ValueNotifier<Book> book = ValueNotifier<Book>(Book());

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
    super.dispose();
  }

  @override
  void onClose() {
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

    book.value = Get.arguments;
    pdfPath = book.value.path!;

    miraiPrint('PdfReaderController pdfPath: $pdfPath');
    pdfFile = File(pdfPath.replaceAll('.pdf', ''));
    miraiPrint('File Path: $pdfPath');
    miraiPrint('File Exists: ${pdfFile?.existsSync()}');

    defaultBrightness = await screenBrightness.current;

  }

  Future<void> close() async {
    screenBrightness.setScreenBrightness(defaultBrightness);

    /// closes overlay if open
    FlutterOverlayWindow.closeOverlay().then((bool? value) => log('STOPPED: value: $value'));
  }

  void setReadingMode(double bright) async {
    brightness.value = bright;
    screenBrightness.setScreenBrightness(bright);
  }

  Future<void> takeQuote() async {
    ///Capture and save to a file

    miraiPrint('takeQuote: capture');
    Uint8List? imageData = await screenshotController.capture();

    if (imageData != null) {
      miraiPrint('takeQuote: imageData != null');
      //   File.fromRawPath(imageData);
      File imageFile = await uint8ListToFile(imageData, 'captured_image');

      CroppedFile? croppedImage = await cropSquareImage(imageFile.path);
      debugPrint('------------ crop true ------------');
      final String size = await getFileSize(croppedImage?.path ?? '', 2);
      debugPrint('size $size');
      if (croppedImage != null) {
        calculateImageDimension(File(croppedImage.path)).then((Size size) =>
            miraiPrint("image size: width * height = ${size.width} * ${size.height}"));
        imageFile = File(croppedImage.path);
      } else {
        debugPrint('crop false');
        // imageFile;
      }

      /// Save Cropped Image to book
      book.value.quotes?.add(imageFile.path);

      await HiveDataStore().updateBook(book: book.value);
    }
    miraiPrint('takeQuote: imageData == null');
  }

  Future<void> overlayWindow() async {
    /// check if overlay permission is granted
    final bool isPermissionGranted = await FlutterOverlayWindow.isPermissionGranted();

    if (!isPermissionGranted) {
      /// request overlay permission
      /// it will open the overlay settings page and return `true` once the permission granted.
      final bool? requestPermission = await FlutterOverlayWindow.requestPermission();
    }

    if (await FlutterOverlayWindow.isActive()) return;

    /// Open overLay content
    ///
    /// - Optional arguments:
    /// `height` the overlay height and default is [overlaySizeFill]
    /// `width` the overlay width and default is [overlaySizeFill]
    /// `OverlayAlignment` the alignment postion on screen and default is [OverlayAlignment.center]
    /// `OverlayFlag` the overlay flag and default is [OverlayFlag.defaultFlag]
    /// `overlayTitle` the notification message and default is "overlay activated"
    /// `overlayContent` the notification message
    /// `enableDrag` to enable/disable dragging the overlay over the screen and default is "false"
    /// `positionGravity` the overlay postion after drag and default is [PositionGravity.none]
    // await FlutterOverlayWindow.showOverlay();

    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "Kotobati",
      // overlayContent: 'Overlay Enabled',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      // height: 500,
      width: WindowSize.matchParent,
    );

    /// broadcast data to and from overlay app
    //  await FlutterOverlayWindow.shareData("Hello from the other side");

    /// streams message shared between overlay and main app
    // FlutterOverlayWindow.overlayListener.listen((event) {
    //   log("Current Event: $event");
    // });

    /// use [OverlayFlag.focusPointer] when you want to use fields that show keyboards
    // await FlutterOverlayWindow.showOverlay(flag: OverlayFlag.focusPointer);

    /// update the overlay flag while the overlay in action
    // await FlutterOverlayWindow.updateFlag(OverlayFlag.defaultFlag);

    /// Update the overlay size in the screen
    // await FlutterOverlayWindow.resizeOverlay(80, 120);
  }

  void enterFullScreen() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: <SystemUiOverlay>[]);
  }

  void exitFullScreen() {
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
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

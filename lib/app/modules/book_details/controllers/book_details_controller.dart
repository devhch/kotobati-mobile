import 'package:get/get.dart';
import 'package:kotobati/app/core/models/book_model.dart';

class BookDetailsController extends GetxController {
  late final Book bookModel;

  RxBool notes = false.obs;

  @override
  void onInit() {
    bookModel = Get.arguments['book'];
    bookModel.notes=  <String>[
      """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
      """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
      "tttttt tttttt tttttt tttttt tttttt tttttt tttttt",
    ];
    bookModel.quotes= <String>[
    """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي."""
    ];
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

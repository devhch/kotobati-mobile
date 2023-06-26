import 'package:get/get.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';

class NotesController extends GetxController {
  RxBool notes = false.obs;

  late Book bookModel;

  @override
  void onInit() {
    bookModel = Book(
      id: "dede",
      title: "ماجدولين ",
      author: "مصطفى لطفي المنفلوطي",
      image: AppIconsKeys.edit,
      notes: <String>[
        """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
        """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.""",
        "tttttt tttttt tttttt tttttt tttttt tttttt tttttt",
      ],
      quotes: <String>[
        """نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي.
نسخة كوتوباتي للقارئ لتنظيم قراءتك و تحسين مستواك الفكري و الثقافي."""
      ],
    );

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

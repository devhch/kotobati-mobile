import 'package:get/get.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';

class PlaningDetailsController extends GetxController {
  late final PlaningBooksModel planingBooksModel;

  @override
  void onInit() {
    planingBooksModel = Get.arguments['planingBooksModel'];

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

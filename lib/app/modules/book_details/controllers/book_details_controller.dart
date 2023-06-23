import 'package:get/get.dart';
import 'package:kotobati/app/core/models/book_model.dart';

class BookDetailsController extends GetxController {
  late final BookModel bookModel;

  RxBool notes = false.obs;

  @override
  void onInit() {
    bookModel = Get.arguments['book'];
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

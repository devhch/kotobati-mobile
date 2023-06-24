import 'package:get/get.dart';
import 'package:kotobati/app/modules/notes/controllers/notes_controller.dart';

import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
    );

    Get.lazyPut<NotesController>(
      () => NotesController(),
    );
  }
}

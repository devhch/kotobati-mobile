import 'package:get/get.dart';
import 'package:kotobati/app/modules/home/controllers/home_controller.dart';
import 'package:kotobati/app/modules/notes/controllers/notes_controller.dart';
import 'package:kotobati/app/modules/planing/controllers/planing_controller.dart';
import 'package:kotobati/app/modules/reading/controllers/reading_controller.dart';

import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
    );

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<ReadingController>(
      () => ReadingController(),
    );

    Get.lazyPut<PlaningController>(
      () => PlaningController(),
    );

    Get.lazyPut<NotesController>(
      () => NotesController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/planing_controller.dart';

class PlaningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaningController>(
      () => PlaningController(),
    );
  }
}

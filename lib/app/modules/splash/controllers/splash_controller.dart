import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_preload_svgs.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/routes/app_pages.dart';

class SplashController extends GetxController {
  String state = 'SplashController ';

  @override
  void onInit() {
    super.onInit();
    miraiPrint("SplashController onInit");
    state += 'init';
  }

  @override
  void onReady() {
    super.onReady();
    state += 'ready';
    go();
  }

  @override
  void onClose() {
    super.onClose();
    miraiPrint("SplashController onClose");
  }

  void go() async {
    await preloadSVGs(
      assets: <String>[
        AppIconsKeys.reading,
        AppIconsKeys.readLater,
        AppIconsKeys.readed,
        AppIconsKeys.addCollection,
        AppIconsKeys.share,
      ],
    );

    final HiveDataStore hiveDataStore = HiveDataStore();
    bool isIntroSeen = hiveDataStore.getIntroSeenState();

    if (isIntroSeen) {
      await Future<void>.delayed(const Duration(seconds: 1), () {});
      Get.offNamed(Routes.navigation);
    } else {
      await Future<void>.delayed(const Duration(seconds: 1), () {});
      Get.offNamed(Routes.intro);
    }
  }
}

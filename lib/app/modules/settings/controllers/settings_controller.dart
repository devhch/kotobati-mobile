import 'package:get/get.dart';
import 'package:kotobati/app/core/models/setting_objects_model.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';

class SettingsController extends GetxController {
  RxDouble zoneDistance = 25.0.obs;
  RxBool darkMode = true.obs;
  RxBool horizontal = true.obs;
  RxBool rating = false.obs;

  late SettingObjectsModel settingObjectsModel;

  @override
  void onInit() {
    HiveDataStore().getSettingObjects().then(
      (SettingObjectsModel value) {
        settingObjectsModel = value;
        zoneDistance.value = settingObjectsModel.spacing;
        darkMode.value = settingObjectsModel.darkMode;
        horizontal.value = settingObjectsModel.horizontal;
        rating.value = settingObjectsModel.rating;
      },
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

  updateSpacing(double distance) async {
    settingObjectsModel.spacing = distance;

    await HiveDataStore()
        .saveSettingObjects(settingObjectsModel: settingObjectsModel);
  }

  updateRatting(bool ratting) async {
    rating.value = ratting;
    settingObjectsModel.rating = rating.value;

    await HiveDataStore()
        .saveSettingObjects(settingObjectsModel: settingObjectsModel);
  }

  updateMode(bool mode) async {
    darkMode.value = mode;
    settingObjectsModel.darkMode = darkMode.value;

    await HiveDataStore()
        .saveSettingObjects(settingObjectsModel: settingObjectsModel);
  }

  updateHorizontal(bool hor) async {
    horizontal.value = hor;
    settingObjectsModel.horizontal = horizontal.value;

    await HiveDataStore()
        .saveSettingObjects(settingObjectsModel: settingObjectsModel);
  }
}

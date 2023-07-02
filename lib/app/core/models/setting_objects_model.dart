/*
* Created By Mirai Devs.
* On 7/2/2023.
*/
class SettingObjectsModel {
  bool horizontal;
  bool darkMode;
  double spacing;
  bool rating;

  SettingObjectsModel({
    this.horizontal = false,
    this.darkMode = true,
    this.spacing = 25,
    this.rating = false,
  });

  factory SettingObjectsModel.fromJson(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(map);

    return SettingObjectsModel(
      horizontal: json['horizontal'],
      darkMode: json['darkMode'],
      spacing: json['spacing'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'horizontal': horizontal,
        'darkMode': darkMode,
        'spacing': spacing,
        'rating': rating,
      };

  @override
  String toString() {
    return 'SettingObjectModel{horizontal: $horizontal, darkMode: $darkMode, spacing: $spacing, rating: $rating}';
  }
}

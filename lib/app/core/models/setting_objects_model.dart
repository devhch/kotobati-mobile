/*
* Created By Mirai Devs.
* On 7/2/2023.
*/
class SettingObjectsModel {
  bool horizontal;
  bool darkMode;
  double spacing;
  double brightness;
  bool rating;

  SettingObjectsModel({
    this.horizontal = false,
    this.darkMode = false,
    this.brightness = 0.0,
    this.spacing = 0,
    this.rating = false,
  });

  factory SettingObjectsModel.fromJson(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(map);

    return SettingObjectsModel(
      horizontal: json['horizontal'],
      darkMode: json['darkMode'],
      brightness: json['brightness'],
      spacing: json['spacing'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'horizontal': horizontal,
        'brightness': brightness,
        'darkMode': darkMode,
        'spacing': spacing,
        'rating': rating,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingObjectsModel &&
          runtimeType == other.runtimeType &&
          horizontal == other.horizontal &&
          darkMode == other.darkMode &&
          spacing == other.spacing &&
          brightness == other.brightness &&
          rating == other.rating;

  @override
  int get hashCode =>
      horizontal.hashCode ^
      darkMode.hashCode ^
      spacing.hashCode ^
      brightness.hashCode ^
      rating.hashCode;

  @override
  String toString() {
    return 'SettingObjectsModel{horizontal: $horizontal, darkMode: $darkMode, spacing: $spacing, brightness: $brightness, rating: $rating}';
  }
}

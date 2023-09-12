/*
* Created By Mirai Devs.
* On 31/7/2023.
*/
import 'dart:convert';
import 'dart:typed_data';

import 'package:kotobati/app/core/utils/app_extension.dart';

class MiraiPDF {
  final String title;
  final String path;
  String size;
  Uint8List? image;

  MiraiPDF({
    this.title = '',
    this.path = '',
    this.size = '',
    this.image,
  });

  factory MiraiPDF.fromJson(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(map);

    return MiraiPDF(
      title: json['title'] ?? '',
      path: json['path'] ?? '',
      size: json['size'] ?? '',
      image: json['image'] == null
          ? Uint8List.fromList(<int>[])
          : Uint8List.fromList(base64.decode(json['image'])),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'path': path,
        'size': size,
        'image': image != null ? base64Encode(image!) : null,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiraiPDF &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          path == other.path &&
          size == other.size &&
          image == other.image;

  @override
  int get hashCode => title.hashCode ^ path.hashCode ^ size.hashCode ^ image.hashCode;

  @override
  String toString() {
    return 'MiraiPDF{title: $title, path: $path, size: $size, image: $image}';
  }
}

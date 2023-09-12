/*
* Created By Mirai Devs.
* On 5/9/2023.
*/

import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadTaskInfo {
  DownloadTaskInfo({required this.name, required this.link});

  final String name;
  final String link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}

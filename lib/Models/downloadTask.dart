import 'package:flutter_downloader/flutter_downloader.dart';

class Task {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  Task({this.name, this.link});
}
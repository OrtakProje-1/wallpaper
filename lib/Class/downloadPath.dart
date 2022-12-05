import 'package:path_provider/path_provider.dart';

class DownloadPath {
  static final DownloadPath _downloadPath = DownloadPath._internal();

  DownloadPath._internal();

  factory DownloadPath() => _downloadPath;

  Future<String?> findLocalPath() async {
    final directory =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    if ((directory ?? []).isEmpty) return null;
    return directory![0].path;
  }
}

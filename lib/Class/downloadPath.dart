
import 'package:path_provider/path_provider.dart';

class DownloadPath {
  static final DownloadPath _downloadPath = DownloadPath._internal();

  DownloadPath._internal();

  factory DownloadPath() => _downloadPath;

  Future<String> findLocalPath() async {
    
    final directory = await getExternalStorageDirectories(type: StorageDirectory.downloads);
    print("downloadPath= ${directory[0].path}");
    return directory[0].path;
  }

  
}

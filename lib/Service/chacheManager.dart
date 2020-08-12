import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CacheManager extends BaseCacheManager {
  static const key = "wallpaperCach";
  static CacheManager _instance;

  CacheManager._internal()
      : super(
          key,
          maxAgeCacheObject:Duration(days: 1),
          maxNrOfCacheObjects:20
        );

  factory CacheManager(){
    _instance??=CacheManager._internal();
    return _instance;
  }

  @override
  Future<String> getFilePath()async {
    var directory=await getTemporaryDirectory();
    return p.join(directory.path,key);
  }


}

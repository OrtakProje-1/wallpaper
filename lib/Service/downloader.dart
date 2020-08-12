import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wallpaperApp/Class/downloadPath.dart';
import 'package:wallpaperApp/Class/permissionsClass.dart';
import 'package:wallpaperApp/Models/downloadTask.dart';
import 'package:wallpaperApp/Service/chacheManager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class Downloader {
  DownloadPath downloadPath = DownloadPath();
  CacheManager customCachManager = CacheManager();
  static final Downloader _downloader = Downloader._internal();

  //private constructor,
  Downloader._internal();
  factory Downloader() => _downloader;


  Future<bool> download(Task task) async {
    
  ReceivePort _port = ReceivePort();
    bool sonuc = await PermissionClass.checkStorage();
    if (sonuc) {
      String _localPath = (await downloadPath
          .findLocalPath()); // Platform.pathSeparator + 'Download'
      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data){
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (progress.toInt() >= 100 && status.value == 3) {
        print("indirme bitti");
      }
    });
    FlutterDownloader.registerCallback(callBack);

      task.taskId = await FlutterDownloader.enqueue(
          url: task.link, savedDir: _localPath, fileName: "${task.name}.jpg");
      print("taskId= ${task.taskId}");

      print("$_localPath${Platform.pathSeparator}${task.name}.jpg");
// bool sonuc = await GallerySaver.saveImage(
//             "$_path${Platform.pathSeparator}${_newTask.name}.jpg",
//             albumName: "H~Wallpaper");
//         if (sonuc) print("Galeriye kayıt başarılı");
      return true;
    } else {
      return false;
    }
  }

  Future<bool> chachDownloadandSetWallpaper(String url, int screen) async {
    bool sonuc = await PermissionClass.checkStorage();
    if (!sonuc) return false;
    try {
      FileInfo info = await customCachManager.downloadFile(url);
      print(info.file.path);
      WallpaperManager.setWallpaperFromFile(info.file.path, screen);
      return true;
    } catch (e) {
      return false;
    }
  }

  saveGalery(String _localPath,Task task)async{
     bool sonuc = await GallerySaver.saveImage(
            "$_localPath${Platform.pathSeparator}${task.name}.jpg",
            albumName: "H~Wallpaper");
        if (sonuc) print("Galeriye kayıt başarılı");
  }

  static void callBack(
      String id, DownloadTaskStatus status, int progress) async {
    SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}

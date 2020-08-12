import 'package:permission_handler/permission_handler.dart';

class PermissionClass{
  static Future<bool> checkStorage()async{
   PermissionStatus status=await Permission.storage.request();
   return status.isGranted;
  }
}